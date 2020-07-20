/* eslint-env mocha */
import proxyquire from 'proxyquire'
import chai, { expect } from 'chai'
import chaiAsPromised from 'chai-as-promised'
import dirtyChai from 'dirty-chai'
import sinon from 'sinon'

chai.use(chaiAsPromised)
chai.use(dirtyChai)

describe('HelloRouter', () => {
  let Router, router, context, getSpy

  function init (error = false) {
    context = {
      body: '',
      query: { error },
      status: 200
    }

    getSpy = sinon.spy()
    Router = proxyquire('../../src/routers/hello', {
      'koa-router': class RouterClass {
        get () { return getSpy() }
      }
    })
  }

  describe('#constructor', () => {
    after(() => {
      router = null
    })

    before(() => {
      init()
      router = new Router()
    })

    it('should create the Router object', () => {
      expect(router).to.exist()

      expect(router.getWorld).to.be.a('function')
      expect(getSpy.calledOnce).to.be.true()
    })
  })

  describe('#getWorld', () => {
    const errorStates = [false, true]

    afterEach(() => {
      context = null
      router = null
    })

    beforeEach(() => {
      init(errorStates.shift())
      router = new Router()
    })

    it('should handle normal get requests', async () => {
      await router.getWorld(context)

      expect(context.body).to.be.a('string')
      expect(context.body).to.equal('Hello World')
      expect(context.status).to.equal(200)
    })
  })
})
