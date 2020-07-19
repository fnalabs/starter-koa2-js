import Router from 'koa-router'

export default class HelloRouter extends Router {
  constructor () {
    super()

    this.get('/hello-world', this.getWorld)
  }

  async getWorld (ctx) {
    ctx.status = 200
    ctx.body = 'Hello World'
  }
}
