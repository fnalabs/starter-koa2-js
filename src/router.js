import Router from 'koa-router';


export default class AppRouter extends Router {

    constructor() {
        super();

        this.get('/hello-world', this.getWorld);
    }

    getWorld = async ctx => {
        let query = ctx.query;

        if (query.error) throw new Error('test error');

        ctx.status = 200;
        return ctx.body = 'Hello World';
    }

}
