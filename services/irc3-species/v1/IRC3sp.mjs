#!/usr/bin/env node

/**
 * IRC3sp.js - Scientific name extraction tool
 * Node.js port of IRC3sp.pl
 */

import fs from 'fs';
import { createReadStream } from 'fs';
import { createInterface } from 'readline';
import { program } from 'commander';

const VERSION = '4.5.2';

// Global variables
/** @type {string[]} */
let table = [];
/** @type {Record<string, number>} */
let genre = {};
/** @type {Record<string, string[]>} */
let liste = {};
/** @type {Record<string, string>} */
let pref = {};
/** @type {Record<string, string>} */
let str = {};
let fleche = '';
let casse = false;
let quiet = false;
/** @type {fs.WriteStream | { write: () => void, end: () => void } | null} */
let logStream = null;

// Setup command line options
program
    .version(VERSION)
    .option('-c, --casse', 'case-sensitive search')
    .option('-l, --log <file>', 'log file for statistics')
    .option('-q, --quiet', 'suppress progress display')
    .option('-t, --table <file>', 'resource table file (required)')
    .parse(process.argv);

const options = program.opts();

// Validate required options
if (!options.table) {
    console.error('Error: -t (table) option is required');
    process.exit(2);
}

// Set global flags
casse = options.casse ?? false;
quiet = options.quiet ?? false;

// Setup log stream
logStream = options.log
    ? fs.createWriteStream(options.log, { encoding: 'utf8' })
    : { write: () => { }, end: () => { } };

/**
 * Normalize a term by splitting on word boundaries
 * @param {string} term
 * @returns {string}
 */
const normalizeTerm = (term) => term
    .split(/(\W)/)          // Split on non-word characters while preserving them
    .filter(p => /\S/.test(p))  // Keep only parts with non-whitespace
    .join(' ')
    .replace(/  +/g, ' ');  // Collapse multiple spaces

/**
 * Extract genus from a scientific name
 * @param {string} term
 * @returns {string}
 */
function extractGenus(term) {
    const match = term.match(/^(\W*\w.*?) .+/);
    return match ? match[1] : term;
}

/**
 * Binary search in sorted array
 * @param {string} key
 * @param {string[]} arr
 * @returns {number}
 */
function binarySearch(key, arr) {
    let binf = -1;
    let bsup = arr.length;

    while (bsup > binf + 1) {
        const bmid = Math.floor((bsup + binf) / 2);
        const comp = key.localeCompare(arr[bmid]);

        if (comp === 0) return bmid;
        if (comp > 0) {
            binf = bmid;
        } else {
            bsup = bmid;
        }
    }

    return -bsup - 1;
}

/**
 * Load resource table
 * @param {string} tablePath
 * @returns {Promise<void>}
 */
async function loadTable(tablePath) {
    if (!quiet) {
        process.stderr.write('\r' + ' '.repeat(75) + '\r Loading resource ...  ');
    }

    const stream = createReadStream(tablePath, { encoding: 'utf8' });

    const rl = createInterface({
        input: stream,
        crlfDelay: Infinity
    });

    for await (const line of rl) {
        // Skip comments and empty lines
        if (line.startsWith('#') || line.trim() === '') continue;

        const cleanLine = line.replace(/\r/g, '');
        let terme, prefForm;

        if (cleanLine.includes('\t')) {
            [terme, prefForm] = cleanLine.split(/\t+/);
        } else {
            terme = cleanLine;
            prefForm = '';
        }

        terme = terme.trim();
        if (!terme || /^\s*$/.test(terme) || /^\w-?$/.test(terme)) {
            if (!quiet) console.error(`Term refused: "${terme}"`);
            continue;
        }

        const originalStr = terme;
        const normalized = normalizeTerm(terme);
        const normalizedKey = casse ? normalized : normalized.toLowerCase();

        if (!str[normalizedKey]) {
            str[normalizedKey] = originalStr;

            const genusStr = extractGenus(originalStr);
            genre[genusStr] = (genre[genusStr] ?? 0) + 1;

            const genusNorm = normalizeTerm(genusStr);
            const genusKey = casse ? genusNorm : genusNorm.toLowerCase();

            if (!str[genusKey]) {
                str[genusKey] = genusStr;
            }

            if (!liste[genusKey]) {
                liste[genusKey] = [];
            }
            liste[genusKey].push(normalizedKey);
        } else {
            logStream?.write(`doublon "${str[normalizedKey]}" et "${originalStr}"\n`);
            continue;
        }

        // Handle preferential form
        if (prefForm) {
            prefForm = prefForm.trim();
            if (!prefForm || /^\s*$/.test(prefForm) || /^\w-?$/.test(prefForm)) {
                if (!quiet) console.error(`Preferential refused: "${prefForm}"`);
                continue;
            }

            const prefOriginal = prefForm;
            const prefNorm = normalizeTerm(prefForm);
            const prefKey = casse ? prefNorm : prefNorm.toLowerCase();

            if (!str[prefKey]) {
                str[prefKey] = prefOriginal;

                const prefGenus = extractGenus(prefOriginal);
                genre[prefGenus] = (genre[prefGenus] ?? 0) + 1;

                const prefGenusNorm = normalizeTerm(prefGenus);
                const prefGenusKey = casse ? prefGenusNorm : prefGenusNorm.toLowerCase();

                if (!str[prefGenusKey]) {
                    str[prefGenusKey] = prefGenus;
                }

                if (!liste[prefGenusKey]) {
                    liste[prefGenusKey] = [];
                }
                liste[prefGenusKey].push(prefKey);
            }

            pref[normalizedKey] = prefOriginal;
        }
    }

    // Build sorted table
    for (const genusKey of Object.keys(liste).sort()) {
        const genusValue = casse ? genusKey : genusKey.toLowerCase();
        // Add genus first, then species (sorted)
        table.push(genusValue, ...liste[genusKey].sort());
    }

    if (table.length === 0) {
        console.error('\r' + ' '.repeat(75) + '\r No terms in the list\n');
        process.exit(3);
    }

    if (!quiet) {
        const nb = table.length.toLocaleString();
        process.stderr.write('\r' + ' '.repeat(75) + `\r ${nb} terms in the list\n`);
    }
}

/**
 * Search for terms in text
 * @param {string} cle
 * @param {string} orig
 * @param {string[] | null} [tref]
 * @returns {string[]}
 */
function recherche(cle, orig, tref = null) {
    const searchTable = tref || table;

    let text = orig.trim();
    let rec = normalizeTerm(text);
    if (!casse) {
        rec = rec.toLowerCase();
    }

    /** @type {string[]} */
    const matches = [];

    while (rec.length > 0) {
        const retour = binarySearch(rec, searchTable);

        if (retour > -1) {
            // Exact match found
            if (!quiet) process.stderr.write('\r' + ' '.repeat(75) + '\r');

            const terme = searchTable[retour];
            let pattern = terme.replace(/(\W)/g, '\\$1').replace(/\\ /g, '\\s*');
            pattern = pattern.replace(/[^\x20-\x7F]/g, '.');

            const regex = casse ? new RegExp(`^${pattern}\\b`) : new RegExp(`^${pattern}\\b`, 'i');
            const match = text.match(regex);

            if (match) {
                const chaine = match[0];
                if (/[A-Z]/.test(chaine)) {
                    matches.push(`${str[terme]}\t${chaine}`);

                    // Handle preferential forms (simplified - no disambiguation yet)
                    if (pref[terme]) {
                        matches[matches.length - 1] += `\t${str[pref[terme]]}`;
                    }
                }
            }

            if (!quiet && !genre[str[terme]]) {
                process.stderr.write(`${cle} ${fleche} ${str[terme]}\n`);
                process.stderr.write(` Processing file ${cle}  `);
            }
        } else {
            // Partial match search
            const insertPos = -2 - retour;
            if (insertPos < searchTable.length && searchTable[insertPos]) {
                const terme = searchTable[insertPos];
                const debut = terme.match(/^(.*?\w+)/);

                if (debut) {
                    let debPattern = debut[1].replace(/(\W)/g, '\\$1');
                    const debRegex = new RegExp(`^${debPattern}\\b`);

                    if (rec.match(debRegex)) {
                        for (let i = insertPos; i < searchTable.length; i++) {
                            const currentTerm = searchTable[i];
                            if (!currentTerm.startsWith(debut[1])) break;

                            let termPattern = currentTerm.replace(/(\W)/g, '\\$1');
                            const termRegex = new RegExp(`^${termPattern}\\b`);

                            if (rec.match(termRegex)) {
                                if (!quiet) process.stderr.write('\r' + ' '.repeat(75) + '\r');

                                termPattern = termPattern.replace(/\\ /g, '\\s*').replace(/[^\x20-\x7F]/g, '.');
                                const textRegex = casse ? new RegExp(`^${termPattern}`) : new RegExp(`^${termPattern}`, 'i');
                                const textMatch = text.match(textRegex);

                                if (textMatch) {
                                    const chaine = textMatch[0];
                                    if (/[A-Z]/.test(chaine)) {
                                        matches.push(`${str[currentTerm]}\t${chaine}`);

                                        if (pref[currentTerm]) {
                                            matches[matches.length - 1] += `\t${str[pref[currentTerm]]}`;
                                        }
                                    }
                                }

                                if (!quiet && !genre[str[currentTerm]]) {
                                    process.stderr.write(`${cle} ${fleche} ${str[currentTerm]}\n`);
                                    process.stderr.write(` Processing file ${cle}  `);
                                }
                                break;
                            }
                        }
                    }
                }
            }
        }

        // Move to next word
        rec = rec.replace(/^\S+\s?/, '');
        // Advance text similar to Perl logic
        if (/^\w+\s*/.test(text)) {
            text = text.replace(/^\w+\s*/, '');
        } else if (/^\s+\W\s*/.test(text)) {
            text = text.replace(/^\s+\W\s*/, '');
        } else if (/^\W\s*/.test(text)) {
            text = text.replace(/^\W\s*/, '');
        } else {
            if (!quiet) console.error(`ERROR advancing text: "${text.substring(0, 50)}"`);
            break;
        }
    }

    return matches;
}

/**
 * Pass 2: Search for abbreviated forms
 * @param {string} id
 * @param {string[]} refListe
 * @param {string[]} refPara
 * @returns {string[]}
 */
function passe2(id, refListe, refPara) {
    try {
        fleche = '=>';

        // Remove duplicates and sort
        let tmp1 = [...new Set(refListe)].sort();

        // Build expanded table with abbreviated forms
        /** @type {string[]} */
        let tmp2 = [];

        for (const item of tmp1) {
            if (!item) continue;
            const parts = item.split('\t');
            const terme = parts[0];
            if (!terme) continue;

            const genusMatch = terme.match(/^(\W*\w.*?) .+/);
            let genusStr = normalizeTerm(genusMatch ? genusMatch[1] : terme);
            if (!casse) genusStr = genusStr.toLowerCase();

            tmp2.push(genusStr);
            if (liste[genusStr]) {
                tmp2.push(...liste[genusStr]);
            } else {
                // Find terms starting with this genus
                tmp2.push(...table.filter(t => t.startsWith(genusStr + ' ')));
            }
        }

        // Remove duplicates and sort
        tmp1 = [...new Set(tmp2)].sort();

        // Build abbreviated forms
        /** @type {Record<string, string>} */
        const tmpPref = {};
        /** @type {Record<string, string>} */
        const tmpStr = {};
        /** @type {string[]} */
        tmp2 = [];

        for (const terme of tmp1) {
            if (!terme) continue;
            tmp2.push(terme);

            if (str[terme]) {
                tmpStr[terme] = str[terme];
            } else {
                if (!quiet) console.error(`No canonical form for "${terme}"`);
                continue;
            }

            // Create abbreviated form (e.g., "Canis lupus" -> "C. lupus")
            const abbrevMatch = casse
                ? terme.match(/^([A-Z])\S+\s+(.+)/)
                : terme.match(/^([a-z])\S+\s+(.+)/);

            if (abbrevMatch) {
                const abrev = `${abbrevMatch[1]}. ${abbrevMatch[2]}`;
                const abrevNorm = normalizeTerm(casse ? abrev : abrev.toLowerCase());
                tmp2.push(abrevNorm);
                tmpStr[abrevNorm] = casse ? abrev : abrev.charAt(0).toUpperCase() + abrev.slice(1);

                if (tmpPref[abrevNorm]) {
                    tmpPref[abrevNorm] += ` ; ${str[terme]}`;
                } else {
                    tmpPref[abrevNorm] = str[terme];
                }
            }
        }

        // Remove duplicates and sort
        tmp1 = [...new Set(tmp2)].sort();

        // Second pass search
        /** @type {string[]} */
        const liste2 = [];
        for (const para of refPara) {
            const matches = recherche(id, para, tmp1);
            for (const match of matches) {
                if (!match) continue;
                const parts = match.split('\t');
                // Resolve abbreviated forms
                if (parts.length >= 2 && parts[0]) {
                    const normalized = normalizeTerm(parts[0]);
                    const key = casse ? normalized : normalized.toLowerCase();

                    if (tmpPref[key]) {
                        const possibles = tmpPref[key].split(' ; ');
                        if (possibles.length === 1) {
                            liste2.push(`${parts[0]}\t${parts[1]}\t${possibles[0]}`);
                        } else {
                            // Ambiguous - mark with ?
                            const ambig = possibles.join('?');
                            liste2.push(`${parts[0]}\t${parts[1]}\t?${ambig}?`);
                        }
                    } else if (tmpStr[key]) {
                        liste2.push(`${parts[0]}\t\t${tmpStr[key]}`);
                    } else {
                        liste2.push(match);
                    }
                }
            }
        }

        // Format output
        /** @type {Record<string, boolean>} */
        const genreSet = {};
        /** @type {string[]} */
        const output = [];

        for (const resultat of liste2) {
            const champs = resultat.split('\t');
            if (genreSet[champs[0]]) continue;

            let formatted;
            if (champs[2]) {
                formatted = `${champs[1]}\t${champs[0]}\t${champs[2]}\t${pref[champs[2]] || ''}`;
            } else {
                formatted = `${champs[1]}\t\t${champs[0]}\t${pref[champs[0]] || ''}`;
            }

            if (!quiet) process.stderr.write('\r' + ' '.repeat(75) + '\r');

            output.push(formatted);

            // Log ambiguities
            if (champs[2] && champs[2].match(/^\?.+\?$/) && !quiet) {
                const msg = `WARNING! ${id}: ambiguity on non-abbreviated form of "${champs[0]}"!\n`;
                process.stderr.write(msg);
                logStream?.write(msg);
            }
        }

        // Write statistics to log
        /** @type {Record<string, number>} */
        const uniqueTerms = {};
        let nbRefs = 0;
        let nbOccs = 0;

        for (const resultat of liste2) {
            if (!resultat) continue;
            const champs = resultat.split('\t');
            const ref = champs[2] || champs[0];
            if (ref && !ref.match(/^\?.+\?$/)) {
                uniqueTerms[ref] = (uniqueTerms[ref] ?? 0) + 1;
            }
        }

        nbRefs = Object.keys(uniqueTerms).length;

        nbOccs = Object.values(uniqueTerms).reduce((a, b) => a + b);

        logStream?.write(`${nbRefs}\t${nbOccs}\t${id}\n`);

        return output;
    } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        console.error(`Error in passe2: ${error.message}`);
        console.error(error.stack);
        throw error;
    }
}

/**
 * Pass 1: Process JSON input
 *
 * Returns string when error.
 * @param {string} input  JSON array of objects with id and value properties
 * @returns {string[] | [string, number] | string}
 */
function passe1(input) {
    try {
        let data;

        try {
            data = JSON.parse(input);
        } catch (err) {
            const error = err instanceof Error ? err : new Error(String(err));
            const msg = error.message.replace(/"/g, '\\"');
            return `{"message": "JSON parsing error", "explanation": "${msg}"}\n`;
        }

        const inputArray = Array.isArray(data) ? data : [data];
        /** @type {string[]} */
        const results = [];

        for (const doc of inputArray) {
            const id = doc.id;
            /** @type {string[]} */
            const values = Array.isArray(doc.value) ? doc.value : [doc.value];

            // First pass
            fleche = '->';
            /** @type {string[]} */
            const para = [];
            /** @type {string[]} */
            const matches = [];

            for (const value of values) {
                para.push(value);
                matches.push(...recherche(id, value));
            }

            // Second pass
            /** @type {string[]} */
            let species = [];
            if (matches.length > 0) {
                const pass2Results = passe2(id, matches, para);

                for (const item of pass2Results) {
                    if (!item) continue;
                    const champs = item.split('\t');
                    if (champs[2] && champs[2].length > 0 && !champs[2].match(/^\?.+\?$/)) {
                        species.push(champs[2]);
                    }
                }
            }

            // Remove duplicates and sort
            species = [...new Set(species)].sort();

            // Format output (webservice mode: compact JSON)
            const obj = { id: id.toString(), value: species };
            results.push(JSON.stringify(obj));
        }

        return [`${results.join('\n')}\n`, 0];
    } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        console.error(`Error in passe1: ${error.message}`);
        console.error(error.stack);
        throw error;
    }
}

/**
 * Process JSON input from stdin
 */
async function traiteJson() {
    let input = '[';

    // Read from stdin
    const rl = createInterface({
        input: process.stdin,
        crlfDelay: Infinity
    });

    for await (const line of rl) {
        input += input === '[' ? line : ',' + line;
    }
    input += input.endsWith(']') ? '' : ']';

    const result = passe1(input);

    const [output, retour] = Array.isArray(result) ? result : [result, 0];

    console.log(output);

    if (retour) {
        process.exit(String(retour));
    }
}

/**
 * Main function
 */
async function main() {
    try {
        // Load resource table
        await loadTable(options.table);

        // Process JSON input from stdin
        await traiteJson();

        // Cleanup
        if (logStream && logStream.end) {
            logStream.end();
        }

        if (!quiet) {
            process.stderr.write('\r' + ' '.repeat(75) + '\r\n');
        }

    } catch (err) {
        const error = err instanceof Error ? err : new Error(String(err));
        console.error(`Error: ${error.message}`);
        process.exit(1);
    }
}

// Run main function
main();
