/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
    var app = new EmberApp(defaults, {
        // Add options here
    });

    // Use `app.import` to add additional libraries to the generated
    // output files.
    //
    // If you need to use different assets in different
    // environments, specify an object as the first parameter. That
    // object's keys should be the environment name and the values
    // should be the asset to use in that environment.
    //
    // If the library that you are including contains AMD or ES6
    // modules that you would like to import into your application
    // please specify an object with the list of modules as keys
    // along with the exports of each module as its value.

    var pickFiles = require('broccoli-static-compiler');
    var mergeTrees = require('broccoli-merge-trees');

    // --- Bootstrap UI framework's dependencies ---
    app.import('bower_components/bootstrap/dist/js/bootstrap.min.js');
    app.import('bower_components/bootstrap/dist/css/bootstrap.min.css');
    var bootstrapMap = pickFiles('bower_components/bootstrap/dist/css', {
                                     srcDir: '/',
                                     files: ['bootstrap.css.map'],
                                     destDir: '/assets'
                                 });
    var bootstrapFonts = pickFiles('bower_components/bootstrap/dist/fonts', {
                                       srcDir: '/',
                                       files: ['glyphicons-halflings-regular.woff',
                                               'glyphicons-halflings-regular.woff2',
                                               'glyphicons-halflings-regular.ttf'],
                                       destDir: '/fonts'
                                   });
    // --- SVG assests ---
      var svgAssests = pickFiles('app/svgs', {
            srcDir: '/',
            files: ['sun.svg',
                    'downtrend_settings.svg',
                    'temperature_trigger_settings.svg',
                    'humidity_threshold_settings.svg'],
            destDir: '/assets'
      });

    // -- Snap.svg - SVG graphics library (https://github.com/adobe-webplatform/Snap.svg) dependencies ---
    app.import('bower_components/Snap.svg/dist/snap.svg-min.js');


    return mergeTrees([app.toTree(),
                       bootstrapMap,
                       bootstrapFonts,
                       svgAssests]);
};
