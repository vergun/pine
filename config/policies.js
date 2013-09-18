/**
 * Policies are simply Express middleware functions which run before your controllers.
 * You can apply one or more policies for a given controller or action.
 *
 * Any policy file (e.g. `authenticated.js`) can be dropped into the `/policies` folder,
 * at which point it can be accessed below by its filename, minus the extension, (e.g. `authenticated`)
 *
 * For more information on policies, check out:
 * http://sailsjs.org/#documentation
 */

module.exports.policies = {
  
  '*': "flashMessage",

  user: {
  	'new': ["flashMessage", "admin"],
    create: "flashMessage",
    show: "userCanSeeProfile",
    edit: "userCanSeeProfile",
    update: "userCanSeeProfile",
    '*': "admin"
  },
  
  article: {
    '*': "flashMessage",
    create: "admin",
    'new': "admin",
    edit: "admin",
    update: "admin",
    save: "admin",
    destroy: "admin"
  }
  
};