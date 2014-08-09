# The new Keats.me

This is the repo for my website, refactored as a node/koa application. It's mostly static content, but I wanted to offload everything I could to the server side to bump up the performance (I also just wanted to play around with es6 and generators). This will allow me to add some cool stuff (json resume, etc) in the near future!

## Layout

* Homepage - a good splash page is still useful, even in the post-postmodern web.
* Blog - maybe I'll actually post stuff in a reasonable timeframe. maybe.
* Projects - a portfolio of projects I've worked on, both client work and personal stuff.
* Resume - I want to experiment with different portrayals of "resume" information, since the web is much more flexible than a black+white printed piece of paper.
* That's it! - personal websites should be lean and mean.

## Tech

* I'm rewriting this site in [koa](http://koajs.com/) and keeping the data in json files. This should speed up pageloads and allow me to do neat things with my data. Templates use the fantastic [jade](http://jade-lang.com/) syntax, styles are in stylus, and any front-end stuff will be written in coffeescript.
* A lot of the code on this site is experimental, and may not follow best practices. Excuse the mess. If you want to check out my actual (read: production-ready, not embarassing) angular code, [here are some open source plugins I've made.](https://github.com/getbolster/angular-utils)