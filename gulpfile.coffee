# load gulp and utils
gulp         = require 'gulp'
gutil        = require 'gulp-util'
changed      = require 'gulp-changed'
gfilter      = require 'gulp-filter'

# load external tasks

# general tasks
concat       = require 'gulp-concat'
rename       = require 'gulp-rename'

# scripts
coffee       = require 'gulp-coffee'
uglify       = require 'gulp-uglify'

# styles
stylus       = require 'gulp-stylus'
csslint      = require 'gulp-csslint'
prefix       = require 'gulp-autoprefixer'
cmq          = require 'gulp-combine-media-queries'
cssmin       = require 'gulp-cssmin'

# images
imagemin     = require 'gulp-imagemin'

# specific tasks
modernizr    = require 'gulp-modernizr'

# tasks

# compiles a new modernizr.js build by parsing our files and seeing what tests we're calling
gulp.task 'modernizr', ->
    gulp.src [
        # styles
        'stylus/*.styl'
    ]
    .pipe modernizr 'modernizr.min.js'
    .pipe uglify()
    .pipe rename 'modernizr.min.js'
    .pipe gulp.dest 'dist/js'

# build stylesheet
gulp.task 'styles', ->
    gulp.src ['node_modules/normalize-css/normlize.css', 'stylus/styles.styl']
        .pipe stylus { compress: true, 'include css': true }
        .pipe concat 'styles.min.css'
        .pipe prefix 'last 2 versions', 'ie 9'
        .pipe cssmin()
        .pipe gulp.dest 'dist/css'

# compress images
gulp.task 'images', ->
    gulp.src 'images/**/*'
        .pipe changed 'dist/images'
        .pipe imagemin { optimizationLevel: 7 }
        .pipe gulp.dest 'dist/images'

# optimize icons
gulp.task 'icons', ->
    gulp.src 'icons/**/*'
        .pipe changed 'dist/icons'
        .pipe imagemin { optimizationLevel: 7 }
        .pipe gulp.dest 'dist/icons'

# watch and auto-build changes
gulp.task 'watch', ->
    # recompile styles when they change
    gulp.watch 'stylus/*.styl', ['styles']

    # recompile individual images if they change
    gulp.watch 'images/**/*', ['images']

    # recompile individual icons if they change
    gulp.watch 'icons/**/*', ['icons']

# default
gulp.task 'default', ['modernizr', 'images', 'icons', 'styles', 'watch']

# server build task
gulp.task 'build', ['modernizr', 'images', 'icons', 'styles']
