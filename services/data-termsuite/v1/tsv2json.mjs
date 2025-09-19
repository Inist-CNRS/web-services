import { readFileSync } from "fs";

const tsv = readFileSync(0).toString("utf-8");
const lines = tsv.split("\n");
const value = lines
    .map((line) => line.split("\t"))
    .map((columns) => ({ key: columns[2], spec: Number(columns[3]), freq: Number(columns[4]) }))
    .slice(1, -1) // remove header and empty line
    .forEach(value => console.log(JSON.stringify(value)))
