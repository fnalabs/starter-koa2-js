import CONFIG from '../conf/appConfig';

// imports
import Koa from 'koa';
import Router from 'koa-router';

import bodyparser from 'koa-bodyparser';
import cors from 'kcors';
import helmet from 'koa-helmet';
import logger from 'koa-logger';

import AppRouter from './router';

const appRouter = new AppRouter();
const healthRouter = new Router().get('/health', ctx => ctx.status = 200);
const app = new Koa();

// bootstrap app
app
    .use(logger())
    .use(bodyparser())
    .use(cors())
    .use(helmet())
    .use(helmet.noCache())
    .use(helmet.referrerPolicy())

    // healthcheck router
    .use(healthRouter.routes())
    .use(healthRouter.allowedMethods())

    // main router
    .use(appRouter.routes())
    .use(appRouter.allowedMethods())

    // handle error response for all other requests
    .use(async ctx => {
        return ctx.status = 404;
    })

    // log any errors that occurred
    // NOTE: errors need to be integrated with log stream
    .on('error', (err, ctx) => {
        console.log(err);

        if (CONFIG.NODE_ENV !== 'production') ctx.body = err;
    });


export default app;
