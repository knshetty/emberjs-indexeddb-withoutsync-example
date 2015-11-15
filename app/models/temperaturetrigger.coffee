`import DS from 'ember-data'`
`import { Model } from 'ember-pouch'`

Temperaturetrigger = Model.extend {

    default: DS.attr('number', {defaultValue: 5})

    onHighHumidity: DS.attr('number', {defaultValue: 4})

    unit: DS.attr('string', {defaultValue: '°C'})

    description: DS.attr('string', {defaultValue: 'Temperature to trigger weather analytics'})

}

`export default Temperaturetrigger`
