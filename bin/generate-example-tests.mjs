#!/usr/bin/env node

// Generate one file for a service instance, which can be used for local tests
// and for remote tests (services/<instance>/tests.hurl)
//
// To test locally, use:
// hurl --test --variable host=http://localhost:31976 --jobs 1 services/<instance>/tests.hurl
//
// To test remotely, use:
// hurl --test --variable host=https://<instance>.services.istex.fr --jobs 1 services/<instance>/tests.hurl
//
// The service should be launched as a local server. URL: http://localhost:31976
// Just launch:
// npm -w services/<instance> run start:dev
// npm run generate:example-tests services/<instance>
// npm -w services/<instance> run stop:dev

import { writeFile } from "fs/promises";
import { RestParser, RestRequest } from "rest-cli";

const usage = (errorNumber = 0) => {
    console.error("Usage:  ./bin/generate-test.mjs services/<instance> [requestName|requestNumber]");
    process.exit(errorNumber);
}

/** @param {string} s */
const isInteger = (s) => Number.isInteger(Number(s));

/** @param {RestRequest} request */
const isText = request => Boolean(
    request.headers.has("Content-Type") &&
    request.headers.get("Content-Type")?.startsWith("text/")
);

const wrapText = text => "```\n" + text + "```\n\n";

/**
 * Converts a REST client request object into a Hurl request.
 *
 * @param {RestRequest} request - The REST client request object to be converted.
 * @return {Promise<string>} The converted Hurl request.
 */
const restCliRequest2Hurl = async (request) => {
    let requestString = `${request.method} ${request.url}\n`
        .replace("http://localhost:31976", "{{host}}");
    request.headers.forEach((value, key) => requestString += `${key}: ${value}\n`);

    if (isText(request)) {
        requestString += wrapText(request.body);
    } else {
        requestString += request.body + '\n';
    }

    try {
        const { response } = await request.request();

        const responseString = "HTTP 200\n" + (isText(request)
            ? wrapText(response.getBody())
            : response.getBody());

        return requestString + responseString + "\n";
    } catch (error) {
        console.error(error);
        return requestString + "\n";
    }
}

/**
 * Converts the entire file by iterating through the RestParser object and
 * converting each request into an Hurl string using the restCliRequest2Hurl
 * function.
 *
 * @param {RestParser} parser - The RestParser object that contains the requests to be converted.
 * @return {Promise<string>} A promise that resolves to the Hurl string representation of all the requests.
 */
const convertWholeFile = async (parser) => {
    const nb = parser.count;
    let hurlString = "";
    for (let i = 0; i < nb; i++) {
        const request = await parser.get(i);
        if (!request) { // Should not happen
            console.error(`Request "${i}" not found.\nMaybe the examples.http file is wrong?`);
            continue;
        }
        hurlString += await restCliRequest2Hurl(request) + '\n';
    }
    return hurlString.trim();
}

///////////////////////////////////////////////////////////:

const [, , instancePath, requestName] = process.argv;

if (!instancePath) {
    console.error("Instance path needed as a first paramater!");
    usage(1);
}

if (process.argv.length > 4) {
    console.error("Wrong number of parameters!");
    usage(2);
}

const instanceName = instancePath.replace(/\/$/, '').split('/').pop();

// Get Response from examples.http file
const parser = new RestParser();
try {
    await parser.readFile(`./${instancePath}/examples.http`);
    parser.files[0].vars.variables.baseUrl = `http://localhost:31976`;
    parser.files[0].vars.variables.host = `http://localhost:31976`;
} catch (error) {
    console.error(`No examples.http file found in ${instancePath}!\n`);
    console.error(error);
    process.exit(5);
}

console.error(`Instance "${instanceName}" found.`);

// Convert all requests
if (process.argv.length === 3) {
    const hurlString = await convertWholeFile(parser);
    console.log(hurlString);
    await writeFile(`./${instancePath}/tests.hurl`, hurlString);
    process.exit(0);
}

const requestId = isInteger(requestName) ? Number(requestName) : requestName;

if (requestId === undefined) {
    console.error("requestName needed as a second parameter (could be a string or an integer).");
    usage(3);
}

const request = await parser.get(requestId);

if (request) {
    console.log(await restCliRequest2Hurl(request));
} else {
    console.error(`Request "${requestId}" not found.`);
    usage(4);
}
