require('newrelic');

var koa = require('koa')
  , route = require('koa-route')
  , views = require('koa-views')
  , serve = require('koa-static')
  , compress = require('koa-compress')
  , json = require('koa-json')
  , cash = require('koa-cash')
  , cache = require('lru-cache')
  , request = require('request')
  , fs = require('fs');

var app = koa();
var c = cache();
var blogposts;

app.use(compress());

// snapshot
app.use(cash({
  get: function* (key) {
    return c.get(key);
  },
  set: function* (key, value) {
    return c.set(key, value);
  }
}));

app.use(function* (next) {
  if (yield* this.cashed()) {
    return;
  }
  yield next;
});

// pretty json
app.use(json());

// jade templates
app.use(views('templates', {
  default: 'jade'
}));

// caching
app.use(function* (next) {
  if (yield* this.cashed()) {
    return;
  }
  yield next;
});

// static files
app.use(serve('dist'));
 
// logger + x-response-time
app.use(function* (next){
  var start = new Date();
  yield next;
  var ms = new Date() - start;
  console.log('%s %s in %sms', this.method, this.url, ms);
  this.set('X-Response-Time', ms + 'ms');
});

// catch 404 errors
app.use(function* (next) {
  yield next;
  if (this.response.status === 404) {
    this.locals.pageName = '404';
    yield this.render('404', this.locals);
  }
});

// ua sniffing for easter eggs
app.use(function* (next) {
  var userAgent = this.request.header['user-agent'];

  function ua(string) {
    return userAgent.toLowerCase().indexOf(string) !== -1;
  }

  if (ua('android')) {
    this.locals.uaClass = 'android';
  } else if (ua('playstation') || ua('nintendo wii') || ua('nitro')) {
    this.locals.uaClass = 'game-console';
  } else {
    this.locals.uaClass = '';
  }

  yield next;
});

// require fs so we can include svg files dynamically
app.use(function* (next) {
  this.locals.fs = fs;
  yield next;
});

// populate data when the server starts
var projects = JSON.parse(fs.readFileSync('data/projects.json'));
var socials = JSON.parse(fs.readFileSync('data/social.json'));
var skills = JSON.parse(fs.readFileSync('data/skills.json'));
var jobs = JSON.parse(fs.readFileSync('data/jobs.json'));
var interests = JSON.parse(fs.readFileSync('data/interests.json'));

// build resume json
var resume = {
  skills: skills,
  experience: jobs,
  interests: interests
};

// get blogposts
request('https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=6&callback=JSON_CALLBACK&q=http://blog.keats.me/rss', function(err, res, body) {
  var data = JSON.parse(body.slice(28, body.length - 1));
  blogposts = data.responseData.feed.entries;
});

// setup routes

// homepage
app.use(route.get('/', function *() {
  this.locals.pageName = 'Homepage';
  this.locals.projects = projects;
  this.locals.blogposts = blogposts;
  this.locals.socials = socials;
  yield this.render('homepage', this.locals);
}));

// work page
app.use(route.get('/work', function *() {
  this.locals.pageName = 'Work';
  this.locals.projects = projects;
  this.locals.socials = socials;
  yield this.render('work', this.locals);
}));

// work json
app.use(route.get('/work.json', function *() {
  var workJson = projects;
  this.body = workJson;
}));

// resume page
app.use(route.get('/resume', function *() {
  this.locals.pageName = 'Resume';
  this.locals.skills = skills;
  this.locals.jobs = jobs;
  this.locals.interests = interests;
  this.locals.socials = socials;
  yield this.render('resume', this.locals);
}));

// resume json
app.use(route.get('/resume.json', function *() {
  this.body = resume;
}));

var port = process.env.PORT || 3000;

app.listen(port);
console.log('listening on port 3000');