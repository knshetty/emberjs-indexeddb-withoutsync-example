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

## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
* Sources of inspiration for this project:
        * https://github.com/broerse/ember-cli-blog
        * https://github.com/nolanlawson/ember-pouch
        * http://www.sitepoint.com/building-offline-first-app-pouchdb/
        * http://pouchdb.com/guides/


