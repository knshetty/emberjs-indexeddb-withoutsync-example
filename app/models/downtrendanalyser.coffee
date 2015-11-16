`import DS from 'ember-data'`
`import { Model } from 'ember-pouch'`

Downtrendanalyser = Model.extend {

    qualifierCount: DS.attr('number', {defaultValue: 3})

    unit: DS.attr('string', {defaultValue: 'hours'})

    description: DS.attr('string', {defaultValue: 'Number of sequencial hourly-temperature-forecasts considered for the identification of down-trend'})
  
}

`export default Downtrendanalyser`
