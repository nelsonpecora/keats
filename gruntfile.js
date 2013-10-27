module.exports = function(grunt) {

	// configure grunt
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		modernizr: {
			'devFile' : 'js/external/modernizr/modernizr.js',
			'outputFile' : 'js/external/modernizr/build/modernizr.min.js',
			tests: [		// manually adding tests until we can exclude folders from auto-detect. we really only need to test stuff in /dashboard/core_views, /dashboard/core_controllers, and /wp-content/themes/bolster
				'flexbox',
				'touch',
				'css-calc',
				'css-positionsticky'
			],
			parseFiles: false
		},
		less: {
			dev: {
				options: {
					paths: ["assets/css"]
				},
				files: {
					"css/styles.css": "less/styles.less"
				}
			},
			prod: {
				options: {
					paths: ["assets/css"],
					yuicompress: true
				},
				files: {
					"css/styles.min.css": "less/styles.less"
				}
			}
		},
		uglify: {
			options: {
				mangle: false, //don't change variable and function names
				sourceMap: false
			},
			scripts: {
				files: {
					'js/scripts.min.js': 'js/scripts.js'
				}
			}
		},
		watch: {
			styles: {
				files: ['less/*.less'],
				tasks: ['less:dev']
			},
			scripts: {
				files: ['coffee/scripts.coffee'],
				tasks: ['coffee']
			},
			html: {
				files: ['pages/*.html', 'partials/*.html'],
				tasks: ['includes']
			}
		},
		coffee: {
			compile: {
				files: {
					'js/scripts.js': 'coffee/scripts.coffee'
				},
				options: {
					sourceMap: false
				}
			}
		},
		includes: {
			build: {
				src: ['pages/*.html'],
				dest: '.',
				cwd: '.',
				flatten: true,
				options: {
					includePath: 'partials/',
					filenameSuffix: '.html'
				}
			}
		}
	});

	// load the tasks
	grunt.loadNpmTasks('grunt-modernizr');
	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-combine-media-queries');
	grunt.loadNpmTasks('grunt-contrib-coffee');
	grunt.loadNpmTasks('grunt-includes');
	grunt.registerTask('scripts', ['coffee', 'uglify']); // compile and minify javascript for production
}