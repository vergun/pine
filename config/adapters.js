// config files are loaded alphabetically
// so load application vars before adaptors
require('./application.js')

module.exports.adapters = {

  'default': 'mongo',
	
	mongo: {
		module   : 'sails-mongo',
    host: appConfig.db.host || 'localhost',
    port: appConfig.db.port || 27017,
    user: appConfig.db.user || '',
    password: appConfig.db.password || '',
    database: appConfig.db.database || 'pine'
	}
    
};