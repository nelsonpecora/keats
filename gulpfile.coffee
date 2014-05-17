# load gulp and utils
gulp         = require 'gulp'
gutil        = require 'gulp-util'
changed      = require 'gulp-changed'
gfilter      = require 'gulp-filter'
print        = require 'gulp-print'
_            = require 'lodash'

# load external tasks

# general tasks
concat       = require 'gulp-concat'
rename       = require 'gulp-rename'

# scripts
coffee       = require 'gulp-coffee'
uglify       = require 'gulp-uglify'
ngmin        = require 'gulp-ngmin'

# styles
stylus       = require 'gulp-stylus'
prefix       = require 'gulp-autoprefixer'
cmq          = require 'gulp-combine-media-queries'
cssmin       = require 'gulp-cssmin'

# images
imagemin     = require 'gulp-imagemin'

# specific tasks
modernizr    = require 'gulp-modernizr'
html         = require 'gulp-file-include'

# input files / globs

# scripts

vendorScripts = [
    'dist/js/modernizr.min.js' # compiled
    'dist/js/fastclick.min.js' # compiled
    'external/angular/angular.min.js'
    'external/angular-animate/angular-animate.min.js'
    'external/angular-touch/angular-touch.min.js'
]

scripts = ['coffee/*.coffee']

# styles
styles = ['stylus/*.styl']

# tasks

# compiles a new modernizr.js build by parsing our files and seeing what tests we're calling
gulp.task 'modernizr', ->
    gulp.src [
        # scripts
        'coffee/*.coffee'
        # styles
        'stylus/*.styl'
    ]
    .pipe modernizr
        devFile: 'external/modernizr/modernizr.js'
        extra:
            shiv: true
        uglify: true
        parseFiles: true
        matchCommunityTests: true
    .pipe uglify()
    .pipe rename 'modernizr.min.js'
    .pipe gulp.dest 'dist/js'

# minifies the vendor files that aren't minified by default
gulp.task 'vendorminfastclick', ->
    gulp.src 'external/fastclick/lib/fastclick.js'
        .pipe uglify()
        .pipe rename 'fastclick.min.js'
        .pipe gulp.dest 'dist/js'

# concats vendor scripts into single file that's served
gulp.task 'vendor', ['modernizr', 'vendorminfastclick'], ->
    gulp.src vendorScripts
    .pipe concat 'vendor.min.js'
    .pipe uglify { mangle: false }
    .pipe gulp.dest 'dist/js'

gulp.task 'scripts', ->
    gulp.src scripts
        .pipe coffee()
        .on 'error', gutil.log
        .on 'error', gutil.beep
        .pipe concat 'scripts.min.js'
        .pipe ngmin()
        .pipe uglify { mangle: false }
        .pipe gulp.dest 'dist/js'

# build stylesheet
gulp.task 'styles', ->
    stylusFilter = gfilter '*.styl'
    gulp.src vendorStyles.concat styles
        .pipe stylusFilter
        .pipe stylus()
        .on 'error', gutil.log
        .on 'error', gutil.beep
        .pipe stylusFilter.restore()
        .pipe concat 'styles.min.css'
        .pipe prefix 'last 2 versions', 'ie 9'
        .pipe cmq()
        .pipe cssmin()
        .pipe gulp.dest 'dist/css'

# build html pages
gulp.task 'allhtml', ->
    gulp.src 'pages/*.html'
        .pipe .html { basepath: '@root' }
        .pipe gulp.dest './'

gulp.task '404html', ->
    gulp.src 'pages/404.html'
        .pipe .html { basepath: '@root' }
        .pipe gulp.dest './'

gulp.task 'indexhtml', ->
    gulp.src 'pages/index.html'
        .pipe .html { basepath: '@root' }
        .pipe gulp.dest './'

gulp.task 'resumehtml', ->
    gulp.src 'pages/resume.html'
        .pipe .html { basepath: '@root' }
        .pipe gulp.dest './'

gulp.task 'workhtml', ->
    gulp.src 'pages/work.html'
        .pipe .html { basepath: '@root' }
        .pipe gulp.dest './'

# compress images
gulp.task 'images', ->
    gulp.src 'images/**/*'
        .pipe changed 'dist/images'
        .pipe imagemin { optimizationLevel: 7 }
        .pipe gulp.dest 'dist/images'

# watch and auto-build changes
gulp.task 'watch', ->
    # recompile scripts when they change
    gulp.watch scripts, ['scripts']

    # recompile styles when they change
    gulp.watch styles, ['styles']

    # recompile all html if partials change
    gulp.watch 'partials/*', ['allhtml']

    gulp.watch 'pages/404.html', ['404html']

    gulp.watch 'pages/index.html', ['indexhtml']

    gulp.watch 'pages/resume.html', ['resumehtml']

    gulp.watch 'pages/work.html', ['workhtml']

    # recompile individual images if they change
    gulp.watch 'images/**/*', ['images']

# default
gulp.task 'default', ['vendor', 'allhtml', 'scripts', 'styles', 'watch']