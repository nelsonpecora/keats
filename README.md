# The new Keats.me

This is the repo for my redesigned website. I separated it from my [blog](http://blog.keats.me), and will mostly just have static content here. I'm building some cool stuff for it, and I'll be able to play around with some of the newest tech without worrying about compatability stuff (sorry IE users).

## Layout

* Homepage - a good splash page is still useful, even in the post-post-modern web.
* Blog - maybe I'll actually post stuff in a reasonable timeframe. maybe.
* Projects - a portfolio of projects I've worked on, both client work and personal stuff.
* Resume - I want to experiment with different portrayals of "resume" information, since the web is much more flexible than a black+white printed piece of paper.
* That's it! - personal websites should be lean and mean.

## Tech

* Holy cow grunt is awesome. Even for a really simple site like this, it makes development easier. I'm auto-generating modernizr scripts, compiling and minifying coffeescript, concatinating and minifying LESS, etc.
* This is my first foray into coffeescript, and the first time I'm using coffeescript with angular. Excuse the mess. If you want to check out my actual (read: production-ready, not embarassing) angular code, [here are some open source plugins](https://github.com/getbolster/angular-utils).
* All of the boilerplate and templating stuff is done in a combination of "include"-ed html (a great grunt plugin) and angular templates. This is definitely overkill for this project, but it's a good reference implementation of super-DRY code without any server-side processing.