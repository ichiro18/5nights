'use strict';

var
    gulp            = require('gulp'),
    notify          = require('gulp-notify'),  //Оповещалки Gulp
    jade            = require('gulp-pug'),  //Шаблонизатор HTML
    sass            = require('gulp-sass'),    //Компилятор SASS в CSS
    autoprefixer    = require('gulp-autoprefixer'),    //Автопроставление префикcов в CSS
    concatCSS       = require('gulp-concat-css'),   //Соединение CSS в один
    minify          = require('gulp-clean-css'),   //Минификатор CSS
    coffee          = require('gulp-coffee'),   //Компилятор Coffee в JS
    concatJS        = require('gulp-concat'), //Соединение JS в один
    sourcemaps      = require('gulp-sourcemaps'), //Карта ресурсов JS
    uglify          = require('gulp-uglify'),   //Минификатор JS
    imagemin        = require('gulp-imagemin'), // Сжатие изображений
    rename          = require('gulp-rename'),  //Переименовывает файлы
    watch           = require('gulp-watch'),   //Следит за изменениями в файлах
    browserSync     = require('browser-sync').create(), //Синхронизация с браузером
    reload          = browserSync.reload    //Перезагрузка браузера
;

var paths = {
    html: ['./app/index.html'],
    css: ['./app/css/**/*.css'],
    js: ['./app/js/**/*.js'],
    img: ['./app/images/**/*.+(png | jpeg)']
};

// HTML !!!!
gulp.task('html:build', function () {
    gulp
        .src('./src/templates/pug/**/*.+(jade|pug)')
        .pipe(jade({pretty: true}))
        .pipe(gulp.dest('./src/templates/build_html'))
        // .pipe(notify('HTML:build Done!'))
    ;
});
gulp.task('html:public', function () {
    gulp
        .src('./src/templates/build_html/**.html')
        .pipe(gulp.dest('./app/'))
        // .pipe(notify('HTML:public Done!'))
    ;
});

// Styles
gulp.task('sass', function () {
    gulp
        .src('./src/style/sass/**/*.+(sass|scss)')
        .pipe(sass())
        .pipe(gulp.dest('./src/style/css/'))
});
gulp.task('css:build', function () {
    gulp
        .src('./src/style/css/**/*.css')
        .pipe(concatCSS('bundle.css')) //Соединяем файлы в один
        .pipe(autoprefixer({
            browsers: ['last 2 versions'],
            cascade: false
        }))
        .pipe(minify()) //Минифицируем CSS
        .pipe(rename('style.min.css')) //Переименовываем
        .pipe(gulp.dest('./src/style/build/custom/'))
        // .pipe(notify('CSS:build Done!'))
    ;
});
gulp.task('css:public', function () {
    gulp
        .src('./src/style/build/custom/**/*.css')
        .pipe(gulp.dest('./app/css/custom/'))
        // .pipe(notify('CSS:public Done!'))
    ;
});

// JS
gulp.task('coffee', function () {
    gulp
        .src('./src/js/coffee/**/*.coffee')
        .pipe(coffee())
        .pipe(gulp.dest('./src/js/js/'))
    ;
});
gulp.task('js:build', function () {
    gulp
        .src('./src/js/js/*.js')
        .pipe(sourcemaps.init())
        .pipe(concatJS('all.js'))
        .pipe(sourcemaps.write())
        .pipe(uglify())
        .pipe(rename('all.min.js'))
        .pipe(gulp.dest('./src/js/build/custom/'))
    // .pipe(notify('CSS:build Done!'))
    ;
});
gulp.task('js:public', function () {
    gulp
        .src('./src/js/build/custom/**/*.js')
        .pipe(gulp.dest('./app/js/custom/'))
    // .pipe(notify('CSS:public Done!'))
    ;
});
// Image
gulp.task('images', function () {
    gulp
        .src('./src/img/**/*.+(png|jpeg|jpg)')
        .pipe(imagemin())
        .pipe(gulp.dest('./app/images'))
});

// fonts
gulp.task('fonts', function () {
    gulp
        .src('./src/fonts/**.*')
        .pipe(gulp.dest('./app/fonts'))
});

// Live Reload
gulp.task('html', function(){
    gulp.src(paths.html)
        .pipe(reload({stream:true}));
});

gulp.task('css', function(){
    return gulp.src(paths.css)
        .pipe(reload({stream:true}));
});

gulp.task('js', function(){
    return gulp.src(paths.js)
        .pipe(reload({stream:true}));
});

gulp.task('img', function(){
    return gulp.src(paths.img)
        .pipe(reload({stream:true}));
});

//Общие задачи
gulp.task('watch', function () {
    // HTML
    gulp.watch('./src/templates/pug/**/*.+(jade|pug)', ['html:build']);
    gulp.watch('./src/templates/build_html/**/*.html', ['html:public']);
    // CSS
    gulp.watch('./src/style/sass/**/*.+(sass|scss)', ['sass']);
    gulp.watch('./src/style/css/**/*.css', ['css:build']);
    gulp.watch('./src/style/build/custom/**/*.css', ['css:public']);
    // JS
    gulp.watch('./src/js/coffee/**/*.coffee', ['coffee']);
    gulp.watch('./src/js/js/**/*.js', ['js:build']);
    gulp.watch('./src/js/build/custom/**/*.js', ['js:public']);
    // BrowserSyncWatch
    gulp.watch(paths.html, ['html']);
    gulp.watch(paths.css, ['css']);
    gulp.watch(paths.script, ['js']);
});

gulp.task('serve', function () {

    browserSync.init({
        server: './app/',
        notify: false
    });

});

// Для выполнения
gulp.task('dev', ['watch', 'serve']);

gulp.task('default', ['html:public', 'css:public']);