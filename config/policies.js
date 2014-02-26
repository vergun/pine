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
  
  '*':          ["flash", "nav", "currentUser"],

  user: {
    'new':      ["flash", "admin", "nav", "currentUser"],
    create:     ["flash", "nav", "currentUser"],
    show:       ["flash", "userCanSeeProfile", "nav", "currentUser"],
    edit:       ["flash", "userCanSeeProfile", "nav", "currentUser"],
    update:     ["flash", "userCanSeeProfile", "nav", "currentUser"],
    populate:   ["flash", "nav", "currentUser"],
    '*':        ["flash", "admin", "nav", "currentUser"]
  },
  
  article: {
    '*':        ["flash", "nav", "currentUser"],
    create:     ["flash", "authenticated", "nav", "currentUser"],
    'new':      ["flash", "authenticated", "nav", "currentUser"],
    edit:       ["flash", "authenticated", "nav", "currentUser"],
    update:     ["flash", "authenticated", "nav", "currentUser"],
    save:       ["flash", "authenticated", "nav", "currentUser"],
    destroy:    ["flash", "authenticated", "nav", "currentUser"],
    fetch:      ["flash", "currentUser"]
  }
  
};