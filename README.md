# Emberjs-indexeddb-withoutsync-example

This [Ember.js](http://emberjs.com/) [ember-cli](http://www.ember-cli.com/) project acts as an example implementation of a Single-Page App, which uses [in-browser database](http://www.codemag.com/article/1411041) to store structured data without syncing with any external data-source. This app doesn't bias any in-browser databases, such as: [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API) or [Web SQL Database](http://html5doctor.com/introducing-web-sql-databases/), however it attempts to abstracts away from specificity of any given in-browser database by using [PouchDB](http://pouchdb.com/) API.

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Env. Version (Tested On)

* ember-cli: 1.13.8
* node: 0.12.7
* npm: 2.13.4
* os: linux x64

## Installation

* `$ git clone https://github.com/knshetty/emberjs-indexeddb-withoutsync-example.git`
* `$ cd emberjs-indexeddb-withoutsync-example/`
* `$ npm install && bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200/emberjs-indexeddb-withoutsync-example/](http://localhost:4200/emberjs-indexeddb-withoutsync-example/).

### Code Generators

Make use of the many generators for code, try `ember help generate` for more details

### Running Tests

* `ember test`
* `ember test --server`

### Building

* `ember build` (development)
* `ember build --environment production` (production)

## How To Bootstrapped This Project From Scratch

        1.  Create an ember-cli project
                `$ ember new emberjs-indexeddb-withoutsync-example`
                `$ cd emberjs-indexeddb-withoutsync-example/`
                `$ npm install && bower install`

        2.   Install build toolchain
                `$ npm install --save-dev broccoli-merge-trees`
                `$ npm install --save-dev broccoli-static-compiler`
                `$ npm install --save-dev ember-cli-coffeescript`

        3. Manage dependencies
                `$ bower install bootstrap --save`
                `$ bower install Snap.svg --save` (https://github.com/adobe-webplatform/Snap.svg)

        4. Setup project build env. using 'ember-cli-build.js' file by include below depedencies
                * 'Bootstrap3' UI framework's dependencies
                * 'Snap.svg' - SVG graphics library dependency

                Now, build this project:
                `$ ember build`

        5. Install ember-cli modules
                `$ npm install --save-dev ember-idx-forms` (Info: http://indexiatech.github.io/ember-forms/overview)
                `$ npm install --save-dev ember-idx-modal` (http://indexiatech.github.io/ember-components)

        6. Conduct a basic smoke test
                `$ ember server`
                Visit the running app at http://0.0.0.0:4200


## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
* Sources of inspiration for this project:
  * http://discuss.emberjs.com/t/is-there-plan-to-have-ember-data-cache-with-a-persistent-in-browser-store/6330/4
  * https://github.com/broerse/ember-cli-blog
  * https://github.com/nolanlawson/ember-pouch
  * http://www.sitepoint.com/building-offline-first-app-pouchdb/
  * http://pouchdb.com/guides/
