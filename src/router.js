import Router from 'koa-router'

export default class AppRouter extends Router {
  constructor () {
    super()

    this.get('/hello-world', this.getWorld)
  }

  async getWorld (ctx) {
    const query = ctx.query

    if (query.error) throw new Error('test error')

    ctx.status = 200
    ctx.body = 'Hello World'
  }
}
