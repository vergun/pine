module.exports.policies = {
  
  '*': ["flash", "nav", "currentUser"],

  user: {
    'new': ["flash", "admin", "nav", "currentUser"],
    create: ["flash", "nav", "currentUser"],
    show: ["flash", "userCanSeeProfile", "nav", "currentUser"],
    edit: ["flash", "userCanSeeProfile", "nav", "currentUser"],
    update: ["flash", "userCanSeeProfile", "nav", "currentUser"],
    populate: ["flash", "nav", "currentUser"],
    '*': ["flash", "admin", "nav", "currentUser"]
  },
  
  article: {
    '*': ["flash", "nav", "currentUser"],
    create: ["flash", "authenticated", "nav", "currentUser"],
    'new': ["flash", "authenticated", "nav", "currentUser"],
    edit: ["flash", "authenticated", "nav", "currentUser"],
    update: ["flash", "authenticated", "nav", "currentUser"],
    save: ["flash", "authenticated", "nav", "currentUser"],
    destroy: ["flash", "authenticated", "nav", "currentUser"]
  }
  
};