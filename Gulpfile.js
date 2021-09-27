var gulp = require('gulp');
var sass = require('gulp-sass')(require('sass'));
var exec = require('gulp-exec');

gulp.task('styles', function(done) {
    gulp.src('gtk-3.0/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./gtk-3.0/'))
        .pipe(exec(' gsettings set org.gnome.desktop.interface gtk-theme "Nordic"'))
    done();
});

gulp.task('shell-style', function(done) {
    gulp.src('gnome-shell/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./gnome-shell/'))
        .pipe(exec('gsettings set org.gnome.shell.extensions.user-theme name "Nordic"'))
    done();
});

gulp.task('cinnamon-style', function(done) {
    gulp.src('cinnamon/**/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest('./cinnamon/'))
    done();
});

//Watch task
gulp.task('default',function() {
    gulp.watch('gtk-3.0/**/*.scss', gulp.series('styles'));
});

gulp.task('shell',function() {
    gulp.watch('gnome-shell/**/*.scss', gulp.series('shell-style'));
});

gulp.task('cinnamon',function() {
    gulp.watch('cinnamon/**/*.scss', gulp.series('cinnamon-style'));
});