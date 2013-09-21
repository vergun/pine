// App dependencies
require('js-yaml')

// Node environment
NODE_ENV = process.env.ENV || 'development'

// Global configuration
global._ = require('underscore')
global.appConfig = require('./application.yml')[NODE_ENV]
global.dbConfig = require('./database.yml')[NODE_ENV]

// Export configuration
module.exports = {
	
	appName: appConfig.application_title || "Pine",
	port: appConfig.application_port || 1337,
	environment: NODE_ENV,

	// Logger
	// Valid `level` configs:
	// 
	// - error
	// - warn
	// - debug
	// - info
	// - verbose
	//
	log: {
		level: 'info'
	}

};