// Application dependency
require('../../../config/application.js')

// Options
process.env.ENV = 'test'
process.env.PORT = appConfig.application_port//Math.floor(Math.random()*10000) + 30000

// Module dependencies
var chai = require('chai')
  , expect = chai.expect
  , should = chai.should()
  , supertest = require('supertest')
  , api = supertest('http://localhost:' + process.env.PORT);
  
// Testing Options
chai.Assertion.includeStack = true;

// Controllers/UserController.js -> new
describe('UserController.new', function() {
  
  // it('should get 200 OK response for an admin', function(done) {
  //   api.get('/user/new')
  //   .expect(200)
  //   .expect('Content-Type', /json/)
  //   .expect('Content-Length', '20')
  //   .end(function(err, res) {
  //     if (err) throw err;
  //     if (res) throw res;
  //     done()
  //   })
  // });

  it('should get 200 Authorized repsonse for a non-admin', function(done) {
    api.get('/user/new')
    .end(function(err, res) {
      console.log(err);
      console.log(res);
    })
    done()
  });

})

// Controllers/UserControler.js -> create
describe('UserController.create', function() {});

// Controllers/UserControler.js -> show
describe('UserController.show', function() {});

// Controllers/UserControler.js -> index
describe('UserController.index', function() {});

// Controllers/UserControler.js -> update
describe('UserController.update', function() {});

// Controllers/UserControler.js -> destroy
describe('UserController.destroy', function() {});




