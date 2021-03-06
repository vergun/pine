// App dependencies
require('js-yaml')

// Node environment
NODE_ENV = process.env.ENV || 'development'

// Global configuration
global._ = require('underscore')
global.async = require('async')
global.log = require('winston')
global.appConfig = require('./application.yml')[NODE_ENV]
global.dbConfig = require('./database.yml')[NODE_ENV]
global.s3Config = require('./s3.yml')[NODE_ENV]
global.startDate = new Date()

// Export configuration
module.exports = {
	appName: appConfig.application_title || "Pine",
	port: appConfig.application_port || 1337,
	environment: NODE_ENV,
	log: { level: appConfig.logger_level }
};