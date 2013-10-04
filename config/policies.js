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
    'new': ["flashMessage", "admin", "nav", "currentUser"],
    // 'new': ["flashMessage", "nav"],
    create: ["flashMessage", "nav", "currentUser"],
    show: ["userCanSeeProfile", "nav", "currentUser"],
    // show: ["nav"],
    edit: ["userCanSeeProfile", "nav", "currentUser"],
    update: ["userCanSeeProfile", "nav", "currentUser"],
    populate: ["flashMessage", "nav", "currentUser"],
    '*': ["admin", "nav", "currentUser"]
  },
  
  article: {
    '*': ["flashMessage", "nav", "currentUser"],
    create: ["authenticated", "nav", "currentUser"],
    'new': ["authenticated", "nav", "currentUser"],
    edit: ["authenticated", "nav", "currentUser"],
    update: ["authenticated", "nav", "currentUser"],
    save: ["authenticated", "nav", "currentUser"],
    destroy: ["authenticated", "nav", "currentUser"]
  }
  
};