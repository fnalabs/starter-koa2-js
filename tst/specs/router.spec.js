import proxyquire from 'proxyquire';
import { expect } from 'chai';

// NOTE: forcing use of proxyquire to shim class dependencies if applicable
const Router = proxyquire('../../src/router', {});

describe('router', () => {
    let router, context;

    function initContext(error = false) {
        context = {
            body: '',
            query: { error },
            status: 200
        };
    }

    beforeEach(() => {
        router = new Router();
    });

    describe('#constructor', () => {
        before(() => {
            router = new Router();
        });

        it('should create the Router object', () => {
            expect(router).to.exist;

            expect(router.getWorld).to.be.a('function');
        });

        after(() => {
            router = null;
        });
    });

    describe('#getWorld', () => {
        const errorStates = [false, true];

        beforeEach(() => {
            initContext(errorStates.shift());
            router = new Router();
        });

        it('should handle normal get requests', async () => {
            await router.getWorld(context);

            expect(context.body).to.be.a('string');
            expect(context.body).to.equal('Hello World');
            expect(context.status).to.equal(200);
        });

        it('should expect a thrown error', async () => {
            try {
                await router.getWorld(context);
            }
            catch (err) {
                expect(err.message).to.be.equal('test error');
            }
        });

        afterEach(() => {
            context = null;
            router = null;
        });

    });

});
