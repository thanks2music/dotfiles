module.exports = function (grunt) {
  var pkg = grunt.file.readJSON('package.json');
  grunt.option("force", true);
  grunt.initConfig({
    compass: {
      dist: {
        options: {
          config: 'config/compass.rb'
        }
      }
    },
    csso: {
      minify_css: {
        expand: true,
        cwd: 'stylesheets/',
        src: ['*.css', '!*.min.css'],
        dest: 'stylesheets/',
        ext: '.min.css'
      }
    },
    csslint: {
      options: {
        csslintrc: '.csslintrc'
      },
      check_style: {
        src: ['stylesheets/*.css']
      }
    },
    imagemin: {
      minify_image: {
        files: [{
          expand: true,
          cwd: 'images/',
          src: ['**/*.{png,jpg,gif}'],
          dest: 'images/'
        }]
      }
    },
    coffee: {
      options: {
        bare: true
      },
      coffee_to_js: {
        expand: true,
        cwd: 'coffee/',
        src: ['*.coffee'],
        dest: 'javascripts/',
        ext: '.js'
      }
    },
    jshint: {
      options: {
        curly: true,
        eqeqeq: true,
        eqnull: true,
        browser: true,
        force: true,
        globals: {
          jQuery: true,
          console: true,
          module: true
        },
      },
      all: ['Gruntfile.js', 'javascripts/*.js']
    },
    uglify: {
      minify_js: {
        files: [{
          expand: true,
          cwd: 'javascripts/',
          src: ['*.js'],
          dest: 'javascripts/',
          ext: '.js'
        }]
      }
    },
    watch: {
      files: ['sass/*.scss', 'coffee/*.coffee'],
      tasks: ['compass', 'csso', 'csslint', 'imagemin', 'coffee', 'jshint', 'uglify']
    }
  });

  var taskName;
  for (taskName in pkg.devDependencies) {
    if (taskName.substring(0, 6) === 'grunt-') {
      grunt.loadNpmTasks(taskName);
    }
  }
  grunt.registerTask('default', ['watch']);
};
