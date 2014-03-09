module.exports = ->

    @initConfig
        pkg: @file.readJSON 'package.json'

        modernizr:
            'devFile': 'js/external/modernizr/modernizr.js'
            'outputFile': 'js/external/modernizr-custom.min.js'
            'extra':
                'shiv': true
            'parseFiles' : true
            'matchCommunityTests': true

            # match all .less and .js files
            'files': [
                # js file
                'js/scripts.js'
                # less files
                'less/*.less'
            ]

            # exclude all test files
            'excludeFiles': [
                '**/tests/**'
            ]

        coffee:
            scripts:
                files:
                    'js/scripts.js': 'coffee/scripts.coffee'
                options:
                    sourceMap: false

            tests:
                files:
                    'tests/scripts.spec.js': 'tests/scripts.spec.coffee'
                options:
                    sourceMap: false

        uglify:
            options:
                mangle: false,      # don't change variable and function names
                sourceMap: false    # don't make a sourcemap

            scripts:
                files:
                    'js/scripts.min.js': 'js/scripts.js'

        imageoptim:
            gif: # requires ImageOptim
                options:
                    jpegMini: false
                    imageAlpha: false
                    quitAfter: true
                src: ['images/**/*.gif']

            png: # requires ImageOptim and ImageAlpha
                options:
                    jpegMini: false
                    imageAlpha: true
                    quitAfter: true
                src: ['images/**/*.png']

            jpeg: # requires ImageOptim and JPEGMini
                options:
                    jpegMini: true
                    imageAlpha: false
                    quitAfter: true
                src: [
                    'images/**/*.jpg'
                    'images/**/*.jpeg'
                ]

        less:
            styles:
                files:
                    'css/styles.css': 'less/styles.less'

        autoprefixer:
            options:
                browsers: [
                    'last 2 version'
                    'ie 8'
                    'ie 9'
                ]

            styles:
                src: 'css/styles.css'
                dest: 'css/styles.css'

        cmq:
            options:
                log: false

            styles:
                src: 'css/styles.css'
                dest: 'css/styles.css'

        cssmin:
            styles:
                files:
                    'css/styles.min.css': [ 'css/styles.css' ]

        watch:
            # recompile modernizr when adding a new version
            modernizr:
                files: ['js/external/modernizr/modernizr.js']
                tasks: ['modernizr']

            styles:
                files: ['less/*.less']
                tasks: ['styles']

            scripts:
                files: ['coffee/scripts.coffee']
                tasks: ['scripts']

            html:
                files: ['pages/*.html', 'partials/*.html']
                tasks: ['includes']

        includes:
            files:
                src: [ 'pages/*.html' ]
                dest: '.'
                cwd: '.'
                flatten: true
                options:
                    includePath: 'partials/'
                    filenameSuffix: '.html'

        karma:
            unit:
                configFile: 'karma.conf.js'
                options:
                    files: [
                        # external files
                        'js/external/modernizr/build/modernizr.min.js'
                        'js/external/angular/angular.min.js'
                        'js/external/angular-mocks/angular-mocks.js'
                        'js/scripts.js'
                        'tests/scripts.spec.js'
                    ]


    # load the tasks
    @loadNpmTasks 'grunt-contrib-less'             # less compilation
    @loadNpmTasks 'grunt-autoprefixer'             # manages browser prefixes, allowing me to write prefix-free code
    @loadNpmTasks 'grunt-combine-media-queries'    # combine bubbled media queries, saving space
    @loadNpmTasks 'grunt-includes'                 # generates the output html
    @loadNpmTasks 'grunt-modernizr'                # generates minified modernizr based on the feature checks I'm running in the code
    @loadNpmTasks 'grunt-contrib-uglify'           # minifies js (both vendor and bolster scripts)
    @loadNpmTasks 'grunt-contrib-cssmin'           # minifies css
    @loadNpmTasks 'grunt-contrib-coffee'           # compiles .coffee files into .js
    @loadNpmTasks 'grunt-contrib-watch'            # watches when files are changed and runs tasks on them
    @loadNpmTasks 'grunt-karma'                    # run unit tests
    @loadNpmTasks 'grunt-imageoptim'               # image optimization (mac only, requires ImageOptim, ImageAlpha, and JPEGMini)
                                                   # ImageOptim (for all files and specifically GIFs) - http://imageoptim.com/
                                                   # ImageAlpha (for PNGs) - http://pngmini.com/
                                                   # JPEGMini (for JPEGs, Mac App Store link) - https://itunes.apple.com/us/app/jpegmini/id498944723
    
    @registerTask('scripts', ['coffee:scripts', 'uglify']); # compile and minify javascript for production
    @registerTask 'styles', [                      # compile .less, auto-prefix, combine media queries, add loading-bar.css, and minify css
        'less'
        'autoprefixer'
        'cmq'
        'cssmin'
    ]
    @registerTask 'test', [                         # unit tests
        'coffee:tests'
        'karma'
    ]