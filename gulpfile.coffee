# load gulp and utils
gulp         = require 'gulp'
gutil        = require 'gulp-util'
changed      = require 'gulp-changed'
gfilter      = require 'gulp-filter'
print        = require 'gulp-print'

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
    .pipe modernizr
        devFile: 'bower_modules/modernizr/modernizr.js'
        extra:
            shiv: true
        uglify: true
        parseFiles: true
        matchCommunityTests: true
    .pipe uglify()
    .pipe rename 'modernizr.min.js'
    .pipe gulp.dest 'dist/js'

# build stylesheet
gulp.task 'styles', ->
    stylusFilter = gfilter '*.styl'
    gulp.src ['bower_modules/normalize-css/normalize.css', 'stylus/styles.styl']
        .pipe stylusFilter
        .pipe stylus()
        .on 'error', gutil.log
        .on 'error', gutil.beep
        .pipe csslint
            'box-sizing': false
            'compatible-vendor-prefixes': false
            'adjoining-classes': false
            'universal-selector': false
            'important': false
            'unique-headings': false
            'outline-none': false
            'unqualified-attributes': false
            'known-properties': false
            'qualified-headings': false
            'box-model': false
            'duplicate-properties': false
            'overqualified-elements': false
            'ids': false
            'font-sizes': false
            'floats': false
            'fallback-colors': false
        .pipe csslint.reporter()
        .pipe stylusFilter.restore()
        .pipe concat 'styles.min.css'
        .pipe prefix 'last 2 versions', 'ie 9'
        .pipe cmq()
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