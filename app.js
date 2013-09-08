// Start sails and pass it command line arguments
require('sails').lift(require('optimist').argv);
log.log("Application started in " + process.env.ENV + " on port " + appConfig.application_port + ".")
