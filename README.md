# The new Keats.me

This is the repo for my redesigned website. I separated it from my [blog](http://blog.keats.me), and will mostly just have static content here. I'm building some cool stuff for it, and I'll be able to play around with some of the newest tech without worrying about compatability stuff (sorry IE users!).

## Layout

* Homepage - a good splash page is still useful, even in the post-postmodern web.
* Blog - maybe I'll actually post stuff in a reasonable timeframe. maybe.
* Projects - a portfolio of projects I've worked on, both client work and personal stuff.
* Resume - I want to experiment with different portrayals of "resume" information, since the web is much more flexible than a black+white printed piece of paper.
* That's it! - personal websites should be lean and mean.

## Tech

* Grunt is awesome, but Gulp is even more awesome! I'm auto-generating modernizr scripts, compiling and minifying coffeescript, concatenating and minifying Stylus, and even generating the html pages from separate partials.
* A lot of the code on this site is experimental, and may not follow best practices. Excuse the mess. If you want to check out my actual (read: production-ready, not embarassing) angular code, [here are some open source plugins I've made.](https://github.com/getbolster/angular-utils)
* All of my stylesheets are written in Stylus, and then processed through autoprefixer (a plugin that allows me to write css without worrying about vendor prefixes) and CMQ (it combines bubbled media queries, saving space and load-time).