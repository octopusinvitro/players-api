const
  browsersync  = require('browser-sync').create(),
  del          = require('del'),
  gulp         = require('gulp'),
  autoprefixer = require('gulp-autoprefixer'),
  concat       = require('gulp-concat'),
  eslint       = require('gulp-eslint'),
  sass         = require('gulp-sass')(require('sass')),
  sourcemaps   = require('gulp-sourcemaps'),
  uglify       = require('gulp-uglify'),

  dev = {
    css: './assets/scss/main.scss',
    img: './assets/img/**',
    js: [
      './assets/js/src/ui.js',
      './assets/js/src/main.js'
    ]
  },

  dist = {
    css: './public/css/',
    img: './public/img/',
    js: './public/js/'
  };

gulp.task('scss', async function() {
  del.sync(`${dist.css}**`);
  gulp
    .src(dev.css)
    .pipe(sourcemaps.init())
    .pipe(sass({ outputStyle: 'compressed' }))
    .pipe(autoprefixer())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(dist.css));
});

gulp.task('js', async function() {
  del.sync(`${dist.js}**`);
  gulp
    .src(dev.js)
    .pipe(sourcemaps.init())
    .pipe(eslint({ configFile: 'eslintrc.json' }))
    .pipe(eslint.format())
    .pipe(eslint.failAfterError())
    .pipe(concat('main.js'))
    .pipe(uglify())
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(dist.js));
});

gulp.task('img', async function() {
  del.sync(`${dist.img}**`);
  gulp
    .src(dev.img)
    .pipe(gulp.dest(dist.img));
});

gulp.task('testlint', async function() {
  gulp
    .src('./assets/js/spec/**')
    .pipe(eslint({ configFile: 'eslintrc.json' }))
    .pipe(eslint.format())
    .pipe(eslint.failAfterError())
})

gulp.task('watch', async function() {
  gulp.watch('./assets/scss/**', gulp.series('scss'));
  gulp.watch(dev.js, gulp.series('js'));
  gulp.watch(dev.img, gulp.series('img'));
  gulp.watch('./assets/scss/**', browsersync.reload);
  gulp.watch(dev.js, browsersync.reload);
  gulp.watch(dev.img, browsersync.reload);
});

gulp.task('server', async function() {
  browsersync.init({
    server: { routes: { '/tests': './assets/js' } },
    port:   4000,
    notify: false,
    open:   false
  });
});

gulp.task('reload', async function(change) {
  browsersync.reload();
  change();
});

gulp.task('default', gulp.parallel('scss', 'js', 'img', 'testlint', 'watch', 'server', 'reload'));
gulp.task('assets', gulp.parallel('scss', 'js', 'img'));
