import { parse } from 'csv-string';
import { createInterface } from 'node:readline';
import type { Route } from '../lib/types';
import type { BusboyFileStream } from '@fastify/busboy';

const csvFields = async (stream: BusboyFileStream): Promise<string[]> => {
    // Create a line reader
    const lineReader = createInterface({
        input: stream,
    });

    // Get the first line
    let firstLine: string | undefined;
    /* eslint-disable no-unreachable-loop */
    // noinspection LoopStatementThatDoesntLoopJS
    for await (const line of lineReader) {
        firstLine = line;
        break;
    }
    /* eslint-enable no-unreachable-loop */

    // Close all streams
    lineReader.close();
    stream.destroy();

    // Return if we don't found any line
    if (!firstLine) {
        return [];
    }

    // Parse the first line with csv-string
    const fields = parse(firstLine);

    // Return if we don't have any data
    if (fields.length < 1) {
        return [];
    }

    // Return the fields
    return fields[0];
};

const path: Route<BusboyFileStream, string[]> = {
    path: '/v1/csv',
    swagger: {
        post: {
            operationId: 'post-v1-csv',
            description: "Récupération des colonnes d'un fichier CSV",
            summary:
                'Le fichier est analysé pour lister les colonnes utilisées',
            tags: ['data-wrapper'],
            requestBody: {
                content: {
                    'text/csv': {
                        schema: {
                            type: 'string',
                            format: 'binary',
                        },
                    },
                },
                required: true,
            },
            responses: {
                default: {
                    description: 'Liste des colonnes trouvées',
                    content: {
                        'application/json': {
                            schema: {
                                $ref: '#/components/schemas/JSONStream',
                            },
                            example: [
                                {
                                    value: 'Title',
                                },
                                {
                                    value: 'Keywords',
                                },
                            ],
                        },
                    },
                },
            },
            parameters: [],
        },
    } as any,
    process: csvFields,
};

export default path;
