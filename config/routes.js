module.exports.routes = {
  '/': {
    controller: 'article',
    action: 'index'
  },
  '/open': {
    controller: 'article',
    action: 'open'
  },
  '/save': {
    controller: 'article',
    action: 'save'
  }
};