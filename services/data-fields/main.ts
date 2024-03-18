import swaggerTemplate from './swagger.json';
import csv from './v1/csv';
import fastifyMultipart from '@fastify/multipart';
import Fastify from 'fastify';
import type { FastifyReply, FastifyRequest } from 'fastify';
import type { OpenAPIV3_1 } from 'openapi-types';

const server = Fastify({
    logger: true,
});

server.register(fastifyMultipart);

const swagger: OpenAPIV3_1.Document = {
    ...swaggerTemplate,
} as any;

if (!swagger.servers) {
    swagger.servers = [];
}

swagger.servers[0] = {
    url: '{scheme}://{hostname}/',
    description: 'Fastify server',
    variables: {
        scheme: {
            description: 'Webservices are accessible via https and/or http',
            enum: ['https', 'http'],
            default: 'https',
        },
        hostname: {
            description:
                'Webservices are accessible via various network interfaces',
            default: 'data-fields.services.istex.fr',
        },
    },
} satisfies OpenAPIV3_1.ServerObject;

if (!swagger.paths) {
    swagger.paths = {};
}

swagger.paths[csv.path] = csv.swagger;
server.post(csv.path, async (request: FastifyRequest, reply: FastifyReply) => {
    const data = await request.file();

    if (!data) {
        return reply.status(400).send();
    }

    return await csv.process(data.file);
});

server.get('/', (request: FastifyRequest) => {
    const localSwagger = {
        ...swagger,
    };
    try {
        (localSwagger as any).servers[0].variables.hostname.default =
            request.hostname;
    } catch (ignored) {}
    return localSwagger;
});

const start = async () => {
    try {
        await server.listen({ host: '0.0.0.0', port: 31976 });
    } catch (err) {
        server.log.error(err);
        process.exit(1);
    }
};

start().then(() => {
    server.log.info('Server started!');
});
