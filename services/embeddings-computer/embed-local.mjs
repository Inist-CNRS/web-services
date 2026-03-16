#!/usr/bin/env node

// embeddings.ts
// Pour Node
// @ts-ignore
globalThis.self = globalThis;

import { env, pipeline } from "@xenova/transformers";
import * as readline from "node:readline/promises";
import { stdin as input, stdout as output } from "node:process";

// 1) Forcer les modèles locaux uniquement
env.allowRemoteModels = false;

// 2) Répertoire racine des modèles pré-téléchargés
//   => par exemple monté dans le container à /models
env.localModelPath = "models";

// 3) Préchargement (optionnel) au démarrage
/** @type {Promise<any> | null} */
let embedderPromise = null;

export function initEmbedder() {
    if (!embedderPromise) {
        embedderPromise = pipeline(
            "feature-extraction",
            // IMPORTANT : chemin *logique* du modèle à l’intérieur de /models
            // Si tu as /models/Xenova/all-MiniLM-L6-v2, tu mets exactement :
            "Xenova/all-MiniLM-L6-v2"
        );
    }
    return embedderPromise;
}

/**
 * @param texts {strings[]}
 * @return {Promise<number[][]>}
 */
export async function embedTexts(texts) {
    const extractor = await initEmbedder();
    const output = await extractor(texts, {
        pooling: "mean",
        normalize: true,
    });

    /** @type {Float32Array} */
    const data = output.data;
    const [batchSize, dim] = output.dims;
    /** @type {number[][]} */
    const vectors = [];
    for (let i = 0; i < batchSize; i++) {
        const start = i * dim;
        const end = start + dim;
        vectors.push(Array.from(data.subarray(start, end)));
    }
    return vectors;
}


///////////////////
const rl = readline.createInterface({ input, output });
for await (const line of rl) {
    const json = JSON.parse(line);
    const { value = [] } = json;
    const texts = Array.isArray(value) ? value : [value];
    const vectors = await embedTexts(texts);
    json.value = vectors;
    console.log(JSON.stringify(json));
}
