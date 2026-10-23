import { readFileSync } from "fs";

const tsv = readFileSync(0).toString("utf-8");
const lines = tsv.split("\n");
const value = lines
    .map((line) => line.split("\t"))
    .map((columns) => ({ key: columns[2], pattern: columns[3], pilot: columns[4], freq: Number(columns[5]), spec: Number(columns[6]), dFreq: Number(columns[7]), tfIdf: Number(columns[8]) }))
    .filter((row) => row.key !== undefined && row.key !== "key") // remove header and empty line
    .forEach(value => console.log(JSON.stringify(value)))
