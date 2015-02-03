// Karma configuration
// http://karma-runner.github.io/0.10/config/configuration-file.html

module.exports = function (config) {
    config.set({
        // base path, that will be used to resolve files and exclude
        basePath: '../../',

        // testing framework to use (jasmine/mocha/qunit/...)
        frameworks: ['jasmine'],

        // list of files / patterns to load in the browser
        files: [
            // bower:js
            'main/webapp/bower_components/es5-shim/es5-shim.js',
            'main/webapp/bower_components/modernizr/modernizr.js',
            'main/webapp/bower_components/jquery/dist/jquery.js',
            'main/webapp/bower_components/stomp-websocket/lib/stomp.min.js',
            'main/webapp/bower_components/sockjs-client/dist/sockjs.js',
            'main/webapp/bower_components/bootstrap-sass/assets/javascripts/bootstrap.js',
            'main/webapp/bower_components/json3/lib/json3.js',
            'main/webapp/bower_components/angular/angular.js',
            'main/webapp/bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
            'main/webapp/bower_components/angular-ui-router/release/angular-ui-router.js',
            'main/webapp/bower_components/angular-ui-utils/ui-utils.js',
            'main/webapp/bower_components/angular-ui-grid/ui-grid.js',
            'main/webapp/bower_components/angular-touch/angular-touch.js',
            'main/webapp/bower_components/angular-resource/angular-resource.js',
            'main/webapp/bower_components/angular-cookies/angular-cookies.js',
            'main/webapp/bower_components/angular-sanitize/angular-sanitize.js',
            'main/webapp/bower_components/angular-translate/angular-translate.js',
            'main/webapp/bower_components/angular-translate-storage-cookie/angular-translate-storage-cookie.js',
            'main/webapp/bower_components/angular-translate-loader-partial/angular-translate-loader-partial.js',
            'main/webapp/bower_components/angular-dynamic-locale/src/tmhDynamicLocale.js',
            'main/webapp/bower_components/angular-translate-loader-static-files/angular-translate-loader-static-files.js',
            'main/webapp/bower_components/angular-local-storage/dist/angular-local-storage.js',
            'main/webapp/bower_components/angular-cache-buster/angular-cache-buster.js',
            'main/webapp/bower_components/moment/moment.js',
            'main/webapp/bower_components/lodash/dist/lodash.compat.js',
            'main/webapp/bower_components/d3/d3.js',
            'main/webapp/bower_components/ng-file-upload-shim/angular-file-upload-shim.js',
            'main/webapp/bower_components/angular-aria/angular-aria.js',
            'main/webapp/bower_components/hammerjs/hammer.js',
            'main/webapp/bower_components/bootstrap-material-design/dist/js/material.js',
            'main/webapp/bower_components/bootstrap-material-design/dist/js/ripples.js',
            'main/webapp/bower_components/jquery-mousewheel/jquery.mousewheel.js',
            'main/webapp/bower_components/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.js',
            'main/webapp/bower_components/select2/select2.js',
            'main/webapp/bower_components/angular-ui-select2/src/select2.js',
            'main/webapp/bower_components/ng-file-upload/angular-file-upload.js',
            'main/webapp/bower_components/angular-breadcrumb/release/angular-breadcrumb.js',
            'main/webapp/bower_components/angular-moment/angular-moment.js',
            'main/webapp/bower_components/highlightjs/highlight.pack.js',
            'main/webapp/bower_components/angular-highlightjs/angular-highlightjs.js',
            'main/webapp/bower_components/angular-mocks/angular-mocks.js',
            // endbower
            'main/webapp/scripts/app/app.js',
            'main/webapp/scripts/app/**/*.js',
            'main/webapp/scripts/components/**/*.js',
            'test/javascript/**/!(karma.conf).js'
        ],


        // list of files / patterns to exclude
        exclude: [],

        // web server port
        port: 9876,

        // level of logging
        // possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
        logLevel: config.LOG_INFO,

        // enable / disable watching file and executing tests whenever any file changes
        autoWatch: false,

        // Start these browsers, currently available:
        // - Chrome
        // - ChromeCanary
        // - Firefox
        // - Opera
        // - Safari (only Mac)
        // - PhantomJS
        // - IE (only Windows)
        browsers: ['PhantomJS'],

        // Continuous Integration mode
        // if true, it capture browsers, run tests and exit
        singleRun: false
    });
};
