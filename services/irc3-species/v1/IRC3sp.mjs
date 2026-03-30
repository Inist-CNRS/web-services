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

const findIndexInSortedArray = (key, arr, compareFn = (a, b) => a.localeCompare(b)) => {
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
     * Find exact match in text
     */
    const findExactMatch = (term, text) => {
        const pattern = buildSearchPattern(term, caseSensitive);
        const match = text.match(pattern);
        return match && isUppercase(match[0]) ? match[0] : null;
    };

    /**
     * Find partial matches for abbreviated genus
     */
    const findPartialMatches = (text, searchTable, startIndex) => {
        const matches = [];
        const genusStart = splitOnWordBoundaries(searchTable[startIndex]).split(' ')[0];

        for (let i = startIndex; i < searchTable.length; i++) {
            const currentTerm = searchTable[i];
            const currentGenus = splitOnWordBoundaries(currentTerm).split(' ')[0];

            if (currentGenus !== genusStart) break;

            const escaped = escapeForRegex(currentTerm).replace(/\\ /g, '\\s*');
            const escapedPattern = escaped.replace(REGEX.NON_ASCII_CHARS, '.');
            const regex = new RegExp(`^${escapedPattern}\\b`, caseSensitive ? '' : 'i');
            const match = text.match(regex);

            if (match && isUppercase(match[0])) {
                const found = match[0];
                let result = `${str[currentTerm]}\t${found}`;

                if (pref[currentTerm]) {
                    result += `\t${str[pref[currentTerm]]}`;
                }

                matches.push(result);
                logger.debug(`  -> Found: ${found}\n`);
                break;
            }
        }

        return matches;
    };

    /**
     * Find scientific names in text
     */
    const findScientificNames = (textToSearch, searchTable = table) => {
        let text = textToSearch.trim();
        let rec = normalizeForLookup(text, caseSensitive);

        /** @type {string[]} */
        const matches = [];

        while (rec.length > 0) {
            const index = findIndexInSortedArray(rec, searchTable);

            if (index > -1) {
                const term = searchTable[index];
                logger.debug(`\r`);
                const found = findExactMatch(term, text);

                if (found) {
                    let matchResult = `${str[term]}\t${found}`;

                    if (pref[term]) {
                        matchResult += `\t${str[pref[term]]}`;
                    }

                    matches.push(matchResult);
                }
            } else {
                const insertPos = -2 - index;
                if (insertPos >= 0 && insertPos < searchTable.length && searchTable[insertPos]) {
                    const partialMatches = findPartialMatches(text, searchTable, insertPos);
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

        const finalSearchTable = uniqueAndSort(expandedTerms);

        /** @type {Record<string, string>} */
        const abbreviationMap = {};
        /** @type {Record<string, string>} */
        const canonicalMap = {};

        for (const term of finalSearchTable) {
            if (!term || !str[term]) continue;

            canonicalMap[normalizeForLookup(term, caseSensitive)] = str[term];

            const abbrev = buildAbbreviation(term);
            if (abbrev) {
                const abbrevKey = normalizeForLookup(abbrev, caseSensitive);
                const abbrevNormalized = caseSensitive ? abbrev : abbrev.toLowerCase();

                const canonicalForm = caseSensitive
                    ? abbrev
                    : abbrev.charAt(0).toUpperCase() + abbrev.slice(1);

                abbreviationMap[abbrevKey] = str[term];
                canonicalMap[abbrevKey] = canonicalForm;
            }
        }

        /** @type {string[]} */
        const resolvedMatches = [];

        for (const para of refPara) {
            const found = findScientificNames(para, finalSearchTable);

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

            const [, foundForm, prefForm] = result.split('\t');
            const formatted = `${foundForm}\t${canonical}\t${pref[canonical] || ''}`;

            logger.debug(`\r`);

            output.push(formatted);

            if (prefForm && prefForm.match(/^\?.+\?$/) && logger) {
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
        .filter((species, index, arr) => arr.indexOf(species) === index)
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

const main = async () => {
    const tablePath = process.env.IRC3SP_TABLE || DEFAULT_TABLE_PATH;
    const caseSensitive = process.env.IRC3SP_CASE_SENSITIVE === 'true';
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
