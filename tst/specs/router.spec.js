import proxyquire from 'proxyquire';
import chai, { expect } from 'chai';
import chaiAsPromised from 'chai-as-promised';
import sinon from 'sinon';

chai.use(chaiAsPromised);

describe('router', () => {
    let Router, router, context, getSpy;

    function init(error = false) {
        context = {
            body: '',
            query: { error },
            status: 200
        };

        getSpy = sinon.spy();
        Router = proxyquire('../../src/router', {
            'koa-router': class RouterClass { get = getSpy }
        });
    }

    describe('#constructor', () => {
        before(() => {
            init();
            router = new Router();
        });

        it('should create the Router object', () => {
            expect(router).to.exist;

            expect(router.getWorld).to.be.a('function');
            expect(getSpy.calledOnce).to.be.true;
        });

        after(() => {
            router = null;
        });
    });

    describe('#getWorld', () => {
        const errorStates = [false, true];

        beforeEach(() => {
            init(errorStates.shift());
            router = new Router();
        });

        it('should handle normal get requests', async () => {
            await router.getWorld(context);

            expect(context.body).to.be.a('string');
            expect(context.body).to.equal('Hello World');
            expect(context.status).to.equal(200);
        });

        it('should expect a thrown error', async () => {
            await expect(router.getWorld(context)).to.eventually.be.rejectedWith(Error);
        });

        afterEach(() => {
            context = null;
            router = null;
        });

    });

});
