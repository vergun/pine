require('js-yaml')
global._ = require('underscore')
NODE_ENV = process.env.ENV || 'development'
global.appConfig = require('./application.yml')[NODE_ENV]

module.exports = {
	
	appName: "Sugar CRM Support",
	port: 1337,
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
		level: 'verbose'
	}

};