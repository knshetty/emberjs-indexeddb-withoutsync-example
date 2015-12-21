`import Ember from 'ember'`

ApplicationRoute = Ember.Route.extend(

    model: ->
        weatherAnalyticsSettings = {
            temperaturetrigger: null
            humiditythreshold: null
            downtrendanalyser: null
        }

        context = @
        @store.findAll('temperaturetrigger').then( (tt)->
            weatherAnalyticsSettings.temperaturetrigger = tt

            context.store.findAll('humiditythreshold').then( (ht)->
                weatherAnalyticsSettings.humiditythreshold = ht

                context.store.findAll('downtrendanalyser').then( (dta)->
                    weatherAnalyticsSettings.downtrendanalyser = dta

                    return weatherAnalyticsSettings
                )
            )
        )

    setupController: (controller, model) ->
        # --- On application being run for the first-time: Initialise & populate records ---
        if model.downtrendanalyser.content.length is 0
            downtrendanalyser = @store.createRecord('downtrendanalyser')
            downtrendanalyser.save()
        if model.temperaturetrigger.content.length is 0
            temperaturetrigger = @store.createRecord('temperaturetrigger')
            temperaturetrigger.save()
        if model.humiditythreshold.content.length is 0
            humiditythreshold = @store.createRecord('humiditythreshold')
            humiditythreshold.save()

        controller.set('model', model)

    # ------------------------------
    # --- Declare Event Handlers ---
    # ------------------------------
    actions:
        updateModel: ->
            @refresh()

        saveTemperatureTrigger: ->
            @modelFor('temperaturetrigger').save()

        saveHumidityThreshold: ->
            @modelFor('humiditythreshold').save()

        saveDownTrendAnalyser: ->
            @modelFor('downtrendanalyser').save()
)

`export default ApplicationRoute`
