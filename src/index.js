// imports
import Koa from 'koa'

import bodyparser from 'koa-bodyparser'
import cors from 'kcors'
import helmet from 'koa-helmet'
import logger from 'koa-logger'

import { HealthRouter, HelloRouter } from './routers'

const healthRouter = new HealthRouter()
const helloRouter = new HelloRouter()
const app = new Koa()

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
  .use(helloRouter.routes())
  .use(helloRouter.allowedMethods())

  // handle error response for all other requests
  .use(async ctx => { ctx.status = 404 })

/*
  // log any errors that occurred
  // NOTE: errors need to be integrated with log stream
  .on('error', err => { console.log(err) })
*/

export default app
