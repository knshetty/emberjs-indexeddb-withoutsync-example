`import DS from 'ember-data'`
`import { Model } from 'ember-pouch'`

Humiditythreshold = Model.extend {

    high: DS.attr('number', {defaultValue: 79})

    low: DS.attr('number', {defaultValue: 34})

    unit: DS.attr('string', {defaultValue: '%'})

    description: DS.attr('string', {defaultValue: 'Relative humidity levels'})

}

`export default Humiditythreshold`
