/* eslint-env mocha */
import proxyquire from 'proxyquire'
import chai, { expect } from 'chai'
import chaiAsPromised from 'chai-as-promised'
import dirtyChai from 'dirty-chai'
import sinon from 'sinon'

chai.use(chaiAsPromised)
chai.use(dirtyChai)

describe('HealthRouter', () => {
  let Router, router, context, getSpy

  function init () {
    context = {
      body: '',
      status: 200
    }

    getSpy = sinon.spy()
    Router = proxyquire('../../src/routers/health', {
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

      expect(router.getHealth).to.be.a('function')
      expect(getSpy.calledOnce).to.be.true()
    })
  })

  describe('#getHealth', () => {
    after(() => {
      context = null
      router = null
    })

    before(() => {
      init()
      router = new Router()
    })

    it('should handle normal get requests', async () => {
      await router.getHealth(context)

      expect(context.body).to.be.a('string')
      expect(context.body).to.equal('OK')
      expect(context.status).to.equal(200)
    })
  })
})
