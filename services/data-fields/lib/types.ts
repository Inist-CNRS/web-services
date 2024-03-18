import type { RouteShorthandOptions } from 'fastify';
import type { OpenAPIV3_1 } from 'openapi-types';

export type Route<I, O> = {
    path: string;
    swagger: OpenAPIV3_1.PathsObject;
    process: (params: I) => Promise<O>;
};
