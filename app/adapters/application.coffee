`import DS from 'ember-data'`
`import config from '../config/environment'`
`import PouchDB from 'pouchdb'`
`import { Adapter } from 'ember-pouch'`

db = new PouchDB(config.local_couch)

ApplicationAdapter = Adapter.extend(

    db: db

    # --- Ember Data 2.0 Reload behavior ---
    shouldReloadRecord: -> return true
    shouldReloadAll: -> return true
    shouldBackgroundReloadRecord: -> return true
    shouldBackgroundReloadAll: -> return true

)

`export default ApplicationAdapter`
