import proxyquire from 'proxyquire';
import request from 'supertest';

describe('app', () => {
    let app;

    before(() => {
        // NOTE: forcing use of proxyquire to shim app dependencies if applicable
        app = proxyquire('../../src/', {}).listen();
    });

    describe('#routes', () => {

        it('should respond with 200 from /health', (done) => {
            request(app)
                .get('/health')
                .expect(200, done);
        });

        it('should respond with 200 and content from /hello-world', (done) => {
            request(app)
                .get('/hello-world')
                .expect(200, 'Hello World', done);
        });

        it('should respond with 500 if an unhandled error is thrown', (done) => {
            request(app)
                .get('/hello-world?error=true')
                .expect(500, done);
        });

        it('should respond with 404 from unspecified routes', (done) => {
            request(app)
                .get('/unspecified')
                .expect(404, 'Not Found', done);
        });
    });

    after(() => {
        app = null;
    });

});
