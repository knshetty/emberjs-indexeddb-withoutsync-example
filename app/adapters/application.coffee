`import DS from 'ember-data'`
`import config from '../config/environment'`
`import PouchDB from 'pouchdb'`
`import { Adapter } from 'ember-pouch'`

db = new PouchDB(config.local_couch)

ApplicationAdapter = Adapter.extend(

    db: db

)

`export default ApplicationAdapter`
