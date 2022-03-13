const
  browsersync  = require('browser-sync').create(),
  del          = require('del'),
  gulp         = require('gulp'),
  autoprefixer = require('gulp-autoprefixer'),
  concat       = require('gulp-concat'),
  eslint       = require('gulp-eslint'),
  replace      = require('gulp-replace'),
  sass         = require('gulp-sass')(require('sass')),
  sourcemaps   = require('gulp-sourcemaps'),
  uglify       = require('gulp-uglify'),

  dev = {
    img: './assets/img/**',
    js: [
      './assets/js/src/prism.js',
      './assets/js/src/selectors.js',
      './assets/js/src/client.js',
      './assets/js/src/ui.js',
      './assets/js/src/main.js'
    ],
    scss: './assets/scss/**',
    spec: './assets/js/spec/**'
  },

  dist = {
    css: './public/css/',
    img: './public/img/',
    js: './public/js/'
  };

function scss() {
  del.sync(`${dist.css}**`);
  return gulp
    .src(dev.scss)
    .pipe(sourcemaps.init())
    .pipe(sass({ outputStyle: 'compressed' }))
    .pipe(autoprefixer())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(dist.css));
}

function js() {
  del.sync(`${dist.js}**`);
  return gulp
    .src(dev.js)
    .pipe(sourcemaps.init())
    .pipe(concat('main.js'))
    .pipe(uglify())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(dist.js));
}

function img() {
  del.sync(`${dist.img}**`);
  return gulp
    .src(dev.img)
    .pipe(gulp.dest(dist.img));
}

function cache() {
  let token = new Date().getTime();
  return gulp
    .src('./views/layout.erb')
    .pipe(replace(/cachebust=\d+/g, 'cachebust=' + token))
    .pipe(gulp.dest('./views/'));
}

function lintJS() {
  return _lint(gulp.src(dev.js));
}

function lintSpec() {
  return _lint(gulp.src(dev.spec));
}

function _lint(files) {
  return files
    .pipe(eslint({ configFile: 'eslintrc.json' }))
    .pipe(eslint.format())
    .pipe(eslint.failAfterError());
}

function watch() {
  gulp.watch(dev.img,  gulp.series(img, cache, reload));
  gulp.watch(dev.js,   gulp.series(lintJS, js, cache, reload));
  gulp.watch(dev.scss, gulp.series(scss, cache, reload));
  gulp.watch(dev.spec, gulp.series(lintSpec));
}

function server() {
  browsersync.init({
    server: { routes: { '/tests': './assets/js' } },
    port:   4000,
    notify: false,
    open:   false
  });
}

function reload(callback) {
  browsersync.reload();
  callback();
}

let assets = gulp.parallel(img, js, scss, cache);
exports.assets = assets;
exports.default = gulp.parallel(assets, server, watch);
