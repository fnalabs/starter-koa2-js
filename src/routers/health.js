import Router from 'koa-router'

export default class HealthRouter extends Router {
  constructor () {
    super()

    this.get('/health', this.getHealth)
  }

  async getHealth (ctx) {
    ctx.status = 200
    ctx.body = 'OK'
  }
}
