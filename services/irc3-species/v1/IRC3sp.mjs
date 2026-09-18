#!/usr/bin/env node

/**
 * IRC3sp.mjs - Scientific name extraction tool
 * Extracts scientific (binomial) species names from text using a reference list.
 */

import fs from 'fs';
import { createReadStream } from 'fs';
import { createInterface } from 'readline';

// ============================================================================
// CONSTANTS
// ============================================================================

const REGEX = Object.freeze({
    WORD_BOUNDARY_SPLIT: /(\W)/,
    NON_WHITESPACE: /\S/,
    MULTIPLE_SPACES: /  +/g,
    GENUS_EXTRACT: /^(\W*\w.*?) .+/,
    ABBREV_EXTRACT: /^([A-Za-z])\S+\s+(.+)/,
    UPPERCASE_TEST: /[A-Z]/,
    CARRIAGE_RETURN: /\r/g,
    NON_ASCII_CHARS: /[^\x20-\x7F]/g,
    WORD_ADVANCE: /^\S+\s?/,
    CAPTURING_WORD: /^\w+\s*/,
    PUNCTUATION_WORD: /^\s+\W\s*/,
    NON_WORD_CHAR: /^\W\s*/,
});

const EXIT_CODES = Object.freeze({
    MISSING_TABLE: 2,
    NO_TERMS: 3,
});

const DEFAULT_TABLE_PATH = '/app/public/v1/CoL.txt';

// ============================================================================
// PURE FUNCTIONS
// ============================================================================

const splitOnWordBoundaries = (term) => term
    .split(REGEX.WORD_BOUNDARY_SPLIT)
    .filter(part => REGEX.NON_WHITESPACE.test(part))
    .join(' ')
    .replace(REGEX.MULTIPLE_SPACES, ' ');

const escapeForRegex = (str) => str
    .replace(/(\W)/g, '\\$1')
    .replace(/\\ /g, '\\s*');

const buildSearchPattern = (term, caseSensitive) => {
    const escaped = escapeForRegex(term);
    const pattern = escaped.replace(REGEX.NON_ASCII_CHARS, '.');
    return new RegExp(`^${pattern}\\b`, caseSensitive ? '' : 'i');
};

const extractGenusFromTerm = (term) => {
    const match = term.match(REGEX.GENUS_EXTRACT);
    return match ? match[1] : term;
};

const buildAbbreviation = (term) => {
    const match = term.match(REGEX.ABBREV_EXTRACT);
    return match ? `${match[1]}. ${match[2]}` : null;
};

const isUppercase = (str) => REGEX.UPPERCASE_TEST.test(str);

const normalizeForLookup = (term, caseSensitive) => {
    const normalized = splitOnWordBoundaries(term);
    return caseSensitive ? normalized : normalized.toLowerCase();
};

const advanceText = (text) => {
    if (REGEX.CAPTURING_WORD.test(text)) {
        return { remaining: text.replace(REGEX.CAPTURING_WORD, ''), consumed: true };
    }
    if (REGEX.PUNCTUATION_WORD.test(text)) {
        return { remaining: text.replace(REGEX.PUNCTUATION_WORD, ''), consumed: true };
    }
    if (REGEX.NON_WORD_CHAR.test(text)) {
        return { remaining: text.replace(REGEX.NON_WORD_CHAR, ''), consumed: true };
    }
    return { remaining: '', consumed: false };
};

const uniqueAndSort = (arr) => [...new Set(arr)].sort();

const parseDocument = (line) => {
    try {
        return { ok: true, value: JSON.parse(line) };
    } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        return { ok: false, error: `JSON parsing error: ${error.message}` };
    }
};

// ============================================================================
// BINARY SEARCH
// ============================================================================

// Binary search: Perl's `cmp` orders strings by code point, which is what
// JS string comparison operators do (locale collation would reorder accented
// keys and break the search).
const compareStrings = (a, b) => (a < b ? -1 : a > b ? 1 : 0);

const findIndexInSortedArray = (key, arr, compareFn = compareStrings) => {
    let binf = -1;
    let bsup = arr.length;

    while (bsup > binf + 1) {
        const bmid = Math.floor((bsup + binf) / 2);
        const comp = compareFn(key, arr[bmid]);

        if (comp === 0) return bmid;
        if (comp > 0) {
            binf = bmid;
        } else {
            bsup = bmid;
        }
    }

    return -bsup - 1;
};

// ============================================================================
// LOGGING
// ============================================================================

const createLogger = (env) => {
    let logStream = { write: () => {}, end: () => {} };

    if (env.IRC3SP_LOG && env.IRC3SP_LOG !== 'false') {
        logStream = fs.createWriteStream(env.IRC3SP_LOG, { encoding: 'utf8' });
    }

    return Object.freeze({
        debug: (msg) => {
            if (env.IRC3SP_DEBUG === 'true') {
                process.stderr.write(msg);
            }
        },
        error: (msg) => console.error(msg),
        writeLog: (msg) => logStream.write(msg),
        close: () => logStream.end(),
    });
};

// ============================================================================
// RESOURCE TABLE LOADING
// ============================================================================

const loadResourceTable = async (tablePath, caseSensitive, logger) => {
    /** @type {Record<string, string>} */
    const strMap = {};
    /** @type {Record<string, number>} */
    const genreCount = {};
    /** @type {Record<string, string[]>} */
    const genusToTerms = {};
    /** @type {Record<string, string>} */
    const prefMap = {};

    const stream = createReadStream(tablePath, { encoding: 'utf8' });
    const rl = createInterface({ input: stream, crlfDelay: Infinity });

    logger.debug(`\r Loading resource table from ${tablePath}...  `);

    for await (const line of rl) {
        if (line.startsWith('#') || line.trim() === '') continue;

        const cleanLine = line.replace(REGEX.CARRIAGE_RETURN, '');
        const [terme, prefForm = ''] = cleanLine.includes('\t')
            ? cleanLine.split(/\t+/)
            : [cleanLine, ''];

        const trimmedTerm = terme.trim();
        if (!trimmedTerm || /^\s*$/.test(trimmedTerm) || /^\w-?$/.test(trimmedTerm)) {
            continue;
        }

        const normalizedKey = normalizeForLookup(trimmedTerm, caseSensitive);

        if (!strMap[normalizedKey]) {
            strMap[normalizedKey] = trimmedTerm;

            const genus = extractGenusFromTerm(trimmedTerm);
            genreCount[genus] = (genreCount[genus] ?? 0) + 1;

            const genusKey = normalizeForLookup(genus, caseSensitive);
            if (!strMap[genusKey]) {
                strMap[genusKey] = genus;
            }

            if (!genusToTerms[genusKey]) {
                genusToTerms[genusKey] = [];
            }
            genusToTerms[genusKey].push(normalizedKey);
        } else {
            logger.writeLog(`doublon "${strMap[normalizedKey]}" et "${trimmedTerm}"\n`);
            continue;
        }

        if (prefForm) {
            const trimmedPref = prefForm.trim();
            if (!trimmedPref || /^\s*$/.test(trimmedPref) || /^\w-?$/.test(trimmedPref)) {
                continue;
            }

            const prefKey = normalizeForLookup(trimmedPref, caseSensitive);
            if (!strMap[prefKey]) {
                strMap[prefKey] = trimmedPref;

                const prefGenus = extractGenusFromTerm(trimmedPref);
                genreCount[prefGenus] = (genreCount[prefGenus] ?? 0) + 1;

                const prefGenusKey = normalizeForLookup(prefGenus, caseSensitive);
                if (!strMap[prefGenusKey]) {
                    strMap[prefGenusKey] = prefGenus;
                }

                if (!genusToTerms[prefGenusKey]) {
                    genusToTerms[prefGenusKey] = [];
                }
                genusToTerms[prefGenusKey].push(prefKey);
            }

            prefMap[normalizedKey] = trimmedPref;
        }
    }

    const table = Object.keys(genusToTerms)
        .sort()
        .flatMap(key => {
            const genusKey = caseSensitive ? key : key.toLowerCase();
            return [genusKey, ...genusToTerms[key].sort()];
        });

    if (table.length === 0) {
        logger.error(` No terms in the list\n`);
        process.exit(EXIT_CODES.NO_TERMS);
    }

    logger.debug(` ${table.length} terms loaded\n`);

    return { table, pref: prefMap, str: strMap };
};

// ============================================================================
// SPECIES EXTRACTOR (CLOSURE)
// ============================================================================

const createSpeciesExtractor = (table, pref, str, caseSensitive, logger) => {

    // Build genusToTerms from table
    /** @type {Record<string, string[]>} */
    const genusToTerms = {};

    for (let i = 0; i < table.length; i++) {
        const term = table[i];
        if (!term) continue;
        const genus = normalizeForLookup(extractGenusFromTerm(str[term] || term), caseSensitive);
        if (!genusToTerms[genus]) {
            genusToTerms[genus] = [];
        }
        genusToTerms[genus].push(term);
    }

    /**
     * Canonical (table) form of a matched term. In the second pass, entries
     * may be abbreviated forms, whose canonical and full forms come from the
     * pass-specific maps instead of the resource table ones.
     */
    const canonicalOf = (term, maps) => (maps ? (maps.canonical[term] ?? str[term]) : str[term]);

    /**
     * Preferred form of a matched term. In the second pass, only abbreviated
     * entries have one (their full form), like Perl's tmpPref hash.
     */
    const prefOf = (term, maps) => {
        if (maps) return maps.abbreviation[term];
        return pref[term] ? str[pref[term]] : undefined;
    };

    /**
     * Build a result row: canonical form, found form, preferred form
     */
    const buildMatchRow = (term, found, maps) => {
        let row = `${canonicalOf(term, maps)}\t${found}`;
        const preferred = prefOf(term, maps);
        if (preferred) {
            row += `\t${preferred}`;
        }
        return row;
    };

    /**
     * Find exact match in text. Genus-only matches are kept: like in Perl,
     * they are filtered out of the output, but they open the genus table for
     * the second pass (abbreviation resolution).
     */
    const findExactMatch = (term, text) => {
        const pattern = buildSearchPattern(term, caseSensitive);
        const match = text.match(pattern);
        if (!match || !isUppercase(match[0])) return null;
        return match[0];
    };

    /**
     * Find the entry whose full normalized form prefixes the remaining text,
     * walking the table backwards from the insertion point (Perl behaviour).
     * Only whole terms are tested: matching a shorter form (e.g. the first two
     * words of an infraspecific or virus name) must not yield the longer name.
     */
    const findPartialMatches = (text, searchTable, startIndex, maps) => {
        const matches = [];
        if (!searchTable[startIndex]) return matches;
        const genusStart = splitOnWordBoundaries(searchTable[startIndex]).split(' ')[0];

        for (let i = startIndex; i >= 0; i--) {
            const currentTerm = searchTable[i];
            const currentGenus = splitOnWordBoundaries(currentTerm).split(' ')[0];
            if (currentGenus !== genusStart) break;

            const regex = buildSearchPattern(currentTerm, caseSensitive);
            const match = text.match(regex);
            if (match && isUppercase(match[0])) {
                const found = match[0];
                matches.push(buildMatchRow(currentTerm, found, maps));
                logger.debug(`  -> Found: ${found}\n`);
                return matches;
            }
        }

        return matches;
    };

    /**
     * Find scientific names in text
     * `searchTable` and `maps` allow a second pass on a reduced table with
     * pass-specific canonical and preferred forms (abbreviation resolution).
     */
    const findScientificNames = (textToSearch, searchTable = table, maps = null) => {
        let text = textToSearch.trim();
        let rec = normalizeForLookup(text, caseSensitive);

        /** @type {string[]} */
        const matches = [];

        while (rec.length > 0) {
            const normalizedRec = rec.trim();
            if (!normalizedRec) break;

            const index = findIndexInSortedArray(normalizedRec, searchTable);

            if (index > -1) {
                const term = searchTable[index];
                const found = findExactMatch(term, text);

                if (found) {
                    matches.push(buildMatchRow(term, found, maps));
                }
            } else {
                const insertPos = -2 - index;
                if (insertPos >= 0 && insertPos < searchTable.length && searchTable[insertPos]) {
                    const partialMatches = findPartialMatches(text, searchTable, insertPos, maps);
                    matches.push(...partialMatches);
                }
            }

            rec = rec.replace(REGEX.WORD_ADVANCE, '');
            const { remaining, consumed } = advanceText(text);

            if (!consumed) {
                logger.debug(`ERROR advancing text: "${text.substring(0, 50)}"\n`);
                break;
            }

            text = remaining;
        }

        return matches;
    };

    /**
     * Resolve abbreviations in found names
     */
    const resolveAbbreviations = (id, refList, refPara) => {
        const uniqueTerms = uniqueAndSort(refList.filter(Boolean));

        /** @type {string[]} */
        const expandedTerms = [];

        for (const item of uniqueTerms) {
            const [terme] = item.split('\t');
            if (!terme) continue;

            const genusStr = normalizeForLookup(
                extractGenusFromTerm(terme),
                caseSensitive
            );

            expandedTerms.push(genusStr);

            if (genusToTerms[genusStr]) {
                expandedTerms.push(...genusToTerms[genusStr]);
            } else {
                expandedTerms.push(
                    ...table.filter(t => t.startsWith(genusStr + ' '))
                );
            }
        }

        // Second-pass table: every candidate term plus its abbreviated form,
        // so that abbreviated occurrences (e.g. “T. recurvata”) can be found,
        // with pass-specific canonical and full forms (Perl's tmpStr/tmpPref).
        const finalSearchTerms = [];
        /** @type {Record<string, string>} */
        const canonicalMap = {};
        /** @type {Record<string, string>} */
        const abbreviationMap = {};

        for (const term of uniqueAndSort(expandedTerms)) {
            if (!term || !str[term]) continue;

            finalSearchTerms.push(term);
            canonicalMap[normalizeForLookup(term, caseSensitive)] = str[term];

            const abbrev = buildAbbreviation(term);
            if (abbrev) {
                const abbrevKey = normalizeForLookup(abbrev, caseSensitive);
                const canonicalForm = caseSensitive
                    ? abbrev
                    : abbrev.charAt(0).toUpperCase() + abbrev.slice(1);

                finalSearchTerms.push(abbrevKey);
                canonicalMap[abbrevKey] = canonicalForm;

                if (abbreviationMap[abbrevKey]) {
                    abbreviationMap[abbrevKey] += ` ; ${str[term]}`;
                } else {
                    abbreviationMap[abbrevKey] = str[term];
                }
            }
        }

        const finalSearchTable = uniqueAndSort(finalSearchTerms);

        /** @type {string[]} */
        const resolvedMatches = [];

        for (const para of refPara) {
            const found = findScientificNames(para, finalSearchTable, {
                canonical: canonicalMap,
                abbreviation: abbreviationMap,
            });

            for (const match of found) {
                if (!match) continue;

                const [canonical, foundForm] = match.split('\t');
                if (!canonical) continue;

                const key = normalizeForLookup(canonical, caseSensitive);
                const possibleFull = abbreviationMap[key];

                if (possibleFull) {
                    const forms = possibleFull.split(' ; ');
                    if (forms.length === 1) {
                        resolvedMatches.push(`${canonical}\t${foundForm}\t${forms[0]}`);
                    } else {
                        resolvedMatches.push(`${canonical}\t${foundForm}\t?${forms.join('?')}?`);
                    }
                } else if (canonicalMap[key]) {
                    resolvedMatches.push(`${canonical}\t\t${canonicalMap[key]}`);
                } else {
                    resolvedMatches.push(match);
                }
            }
        }

        /** @type {Record<string, boolean>} */
        const seen = {};
        /** @type {string[]} */
        const output = [];

        for (const result of resolvedMatches) {
            const [canonical] = result.split('\t');
            if (seen[canonical]) continue;
            seen[canonical] = true;

            const [, foundForm, fullForm] = result.split('\t');
            const formatted = `${foundForm ?? ''}\t${canonical}\t${fullForm ?? ''}`;

            logger.debug(`\r`);

            output.push(formatted);

            if (fullForm && fullForm.match(/^\?.+\?$/) && logger) {
                const msg = `WARNING! ${id}: ambiguity on non-abbreviated form of "${canonical}"!\n`;
                logger.error(msg);
                logger.writeLog(msg);
            }
        }

        return output;
    };

    return { findScientificNames, resolveAbbreviations };
};

// ============================================================================
// PROCESS DOCUMENT
// ============================================================================

const processDocument = (doc, extractor) => {
    const { id, value } = doc;
    const paragraphs = Array.isArray(value) ? value : [value];

    const rawMatches = paragraphs.flatMap(p => extractor.findScientificNames(p));

    if (rawMatches.length === 0) {
        return { id: String(id), value: [] };
    }

    const resolved = extractor.resolveAbbreviations(id, rawMatches, paragraphs);

    const species = resolved
        .map(result => {
            const champs = result.split('\t');
            const canonical = champs[2] || champs[1];
            return canonical;
        })
        .filter(Boolean)
        // Ambiguous abbreviated forms must not yield a species (Perl's passe1)
        .filter(name => !/^\?.+\?$/.test(name))
        .filter(name => name.includes(' '))
        .filter((name, index, arr) => arr.indexOf(name) === index)
        .sort();

    return { id: String(id), value: species };
};

// ============================================================================
// STREAMING JSONL PROCESSING
// ============================================================================

const processJsonlStream = async (extractor) => {
    const rl = createInterface({
        input: process.stdin,
        crlfDelay: Infinity
    });

    for await (const line of rl) {
        const trimmed = line.trim();
        if (!trimmed) continue;

        const parsed = parseDocument(trimmed);

        if (!parsed.ok) {
            console.log(JSON.stringify({
                message: 'JSON parsing error',
                explanation: parsed.error
            }));
            continue;
        }

        const result = processDocument(parsed.value, extractor);
        console.log(JSON.stringify(result));
    }
};

// ============================================================================
// MAIN
// ============================================================================

/**
 * Command line options, mirroring the Perl script ones: -t table, -c casse.
 * Other options (-w, -j, -f, ...) are accepted for compatibility but unused:
 * the script always reads JSON lines from stdin.
 */
const parseArgs = (argv) => {
    const options = { casse: false, table: undefined };

    for (let i = 0; i < argv.length; i++) {
        const arg = argv[i];
        if (arg === '-t' || arg === '--table') {
            options.table = argv[++i];
        } else if (arg === '-c' || arg === '--casse') {
            options.casse = true;
        }
    }

    return options;
};

const main = async () => {
    const options = parseArgs(process.argv.slice(2));
    const tablePath = options.table ?? process.env.IRC3SP_TABLE ?? DEFAULT_TABLE_PATH;
    const caseSensitive = options.casse || process.env.IRC3SP_CASE_SENSITIVE === 'true';
    const logger = createLogger(process.env);

    if (!tablePath) {
        logger.error('Error: IRC3SP_TABLE environment variable is required');
        process.exit(EXIT_CODES.MISSING_TABLE);
    }

    try {
        const { table, pref, str } = await loadResourceTable(tablePath, caseSensitive, logger);
        const extractor = createSpeciesExtractor(table, pref, str, caseSensitive, logger);

        await processJsonlStream(extractor);

        logger.close();

        if (process.env.IRC3SP_DEBUG === 'true') {
            process.stderr.write('\r\n');
        }

    } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        logger.error(`Error: ${error.message}`);
        process.exit(1);
    }
};

main();
