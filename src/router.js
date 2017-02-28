import Router from 'koa-router';


export default class AppRouter extends Router {

    constructor() {
        super();

        this.get('/hello-world', this.getWorld);
    }

    getWorld = async ctx => {
        ctx.status = 200;
        return ctx.body = 'Hello World';
    }

}
