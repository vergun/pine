/**
 * Bootstrap
 *
 * An asynchronous boostrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#documentation
 */

module.exports.bootstrap = function (cb) {
  
  var git         = require("gift");
  var repo        = git("Pine_Needles");
  cb();

  if (appConfig && appConfig.submodule && appConfig.submodule.path) {
    repo.checkout(appConfig.submodule.branch, function() {
      cb();
    })
  } else {
      log.warn("Application.yml error: please fix your application.yml then 'sails lift'")
  }

};