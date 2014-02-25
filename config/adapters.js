// config files are loaded alphabetically
// so load application vars before adaptors
require('./application.js')

module.exports.adapters = {

  default: 'mongo',	
	mongo: {
		module   : 'sails-mongo',
    host: dbConfig.mongo.host || 'localhost',
    port: dbConfig.mongo.port || 27017,
    user: dbConfig.mongo.user || '',
    password: dbConfig.mongo.password || '',
    database: dbConfig.mongo.database || 'pine'
	}
    
};