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
  
  '*': ["flashMessage", "nav", "currentUser"],

  user: {
    // 'new': ["flashMessage", "admin", "nav", "currentUser"],
    'new': ["flashMessage", "nav"],
    create: ["flashMessage", "nav", "currentUser"],
    show: ["userCanSeeProfile", "nav", "currentUser"],
    edit: ["userCanSeeProfile", "nav", "currentUser"],
    update: ["userCanSeeProfile", "nav", "currentUser"],
    '*': ["admin", "nav", "currentUser"]
  },
  
  article: {
    '*': ["flashMessage", "nav", "currentUser"],
    create: ["admin", "nav", "currentUser"],
    'new': ["admin", "nav", "currentUser"],
    edit: ["admin", "nav", "currentUser"],
    update: ["admin", "nav", "currentUser"],
    save: ["admin", "nav", "currentUser"],
    destroy: ["admin", "nav", "currentUser"]
  }
  
};