`import Ember from 'ember'`

WeatherAnalyticsSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ----------------
    # Declare: Globals
    # ----------------
    _extractedAllWeatherAnalyticsSettings: false

    _default_TemperatureTrigger_SvgObj: null
    _onHighHumidity_TemperatureTrigger_SvgObj: null

    _high_HumidityThershold_SvgObj: null
    _low_HumidityThershold_SvgObj: null

    dtaQualifierCount: null
    dtaUnitOfQualifierCount: null

    defaultTemperatureTrigger: null
    onHighHumidityTemperatureTrigger: null
    unitOfTemperatureTrigger: null

    highHumidityThreshold: null
    lowHumidityThreshold: null
    unitOfHumidityThreshold: null

    # -------------------------------------
    # Declare: Component Specific Functions
    # -------------------------------------
    didInsertElement: ->

        # Create snap.svg context
        @_snapsvgInit()

        # Get handle to Clock svg
        s = @get('draw')

        # Manipulate Clock svg objects
        Snap.load('assets/weather.svg', ((f) ->

            # Extract data from model
            @_extractWeatherAnalyticsSettings()

            arrowButtonColour_Default = '#808080'

            # ---------------------------
            # --- Down-Trend Analyser ---
            # ---------------------------
            # Get all related svg objects
            qualifierCount_DTA = f.select('#qualifier_count_dta')
            unit_QualifierCount_DTA = f.select('#unit_qualifier_count_dta')
            upArrow_QualifierCount_DTA = f.select('#uparrow_qualifier_count_dta')
            downArrow_QualifierCount_DTA = f.select('#downarrow_qualifier_count_dta')

            # Initialise digit & unit
            qualifierCount_DTA.node.textContent = @dtaQualifierCount
            unit_QualifierCount_DTA.node.textContent = @dtaUnitOfQualifierCount

            # Digit-Increment handler
            upArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_QualifierCount_DTA.mouseup( ( ->
                upArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickIncrement_QualifierCount(qualifierCount_DTA)
                @set('dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # Digit-Decrement handler
            downArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_QualifierCount_DTA.mouseup( ( ->
                downArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickDecrement_QualifierCount(qualifierCount_DTA)
                @set('dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # ---------------------------
            # --- Temperature Trigger ---
            # ---------------------------
            # Get all related svg objects
            default_TemperatureTrigger = f.select('#default_temperaturetrigger')
            @set('_default_TemperatureTrigger_SvgObj', default_TemperatureTrigger)
            unit_Default_TemperatureTrigger = f.select('#unit_default_temperaturetrigger')
            upArrow_Default_TemperatureTrigger = f.select('#uparrow_default_temperaturetrigger')
            downArrow_Default_TemperatureTrigger = f.select('#downarrow_default_temperaturetrigger')

            onHighHumidity_TemperatureTrigger = f.select('#onhighhumidity_temperaturetrigger')
            @set('_onHighHumidity_TemperatureTrigger_SvgObj', onHighHumidity_TemperatureTrigger)
            unit_OnHighHumidity_TemperatureTrigger = f.select('#unit_onhighhumidity_temperaturetrigger')
            upArrow_OnHighHumidity_TemperatureTrigger = f.select('#uparrow_onhighhumidity_temperaturetrigger')
            downArrow_OnHighHumidity_TemperatureTrigger = f.select('#downarrow_onhighhumidity_temperaturetrigger')

            # Initialise digit & unit
            default_TemperatureTrigger.node.textContent = @defaultTemperatureTrigger
            unit_Default_TemperatureTrigger.node.textContent = @unitOfTemperatureTrigger

            onHighHumidity_TemperatureTrigger.node.textContent = @onHighHumidityTemperatureTrigger
            unit_OnHighHumidity_TemperatureTrigger.node.textContent = @unitOfTemperatureTrigger

            # Digit-Increment handlers
            upArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Default_TemperatureTrigger.mouseup( ( ->
                upArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('defaultTemperatureTrigger', @_onClickIncrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            upArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                upArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('onHighHumidityTemperatureTrigger', @_onClickIncrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Default_TemperatureTrigger.mouseup( ( ->
                downArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('defaultTemperatureTrigger', @_onClickDecrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            downArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                downArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('onHighHumidityTemperatureTrigger', @_onClickDecrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # --------------------------
            # --- Humidity Threshold ---
            # --------------------------
            # Get all related svg objects
            high_HumidityThershold = f.select('#high_humiditythershold')
            @set('_high_HumidityThershold_SvgObj', high_HumidityThershold)
            unit_High_HumidityThershold = f.select('#unit_high_humiditythershold')
            upArrow_High_HumidityThershold = f.select('#uparrow_high_humiditythershold')
            downArrow_High_HumidityThershold = f.select('#downarrow_high_humiditythershold')

            low_HumidityThershold = f.select('#low_humiditythershold')
            @set('_low_HumidityThershold_SvgObj', low_HumidityThershold)
            unit_Low_HumidityThershold = f.select('#unit_low_humiditythershold')
            upArrow_Low_HumidityThershold = f.select('#uparrow_low_humiditythershold')
            downArrow_Low_HumidityThershold = f.select('#downarrow_low_humiditythershold')

            # Initialise digit & unit
            high_HumidityThershold.node.textContent = @highHumidityThreshold
            unit_High_HumidityThershold.node.textContent = @unitOfHumidityThreshold

            low_HumidityThershold.node.textContent = @lowHumidityThreshold
            unit_Low_HumidityThershold.node.textContent = @unitOfHumidityThreshold

            # Digit-Increment handlers
            upArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_High_HumidityThershold.mouseup( ( ->
                upArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('high_HumidityThershold', @_onClickIncrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            upArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Low_HumidityThershold.mouseup( ( ->
                upArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('low_HumidityThershold', @_onClickIncrement_LowHumidityThreshold(low_HumidityThershold))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_High_HumidityThershold.mouseup( ( ->
                downArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('high_HumidityThershold', @_onClickDecrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            downArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Low_HumidityThershold.mouseup( ( ->
                downArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('low_HumidityThershold', @_onClickDecrement_LowHumidityThreshold(low_HumidityThershold))
            ).bind(@))

            s.append(f)

        ).bind(@))

    # ------------------------
    # Declare: Local Functions
    # ------------------------
    _snapsvgInit: ->
        draw = Snap('#weather-analytics-settings-wrapper')
        @set('draw', draw)

    _extractWeatherAnalyticsSettings: ->
        # --- Down-Trend Analyser details ---
        @set('dtaQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('qualifierCount'))
        @set('dtaUnitOfQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('unit'))
        # --- Temperature Trigger details ---
        @set('defaultTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('default'))
        @set('onHighHumidityTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('onHighHumidity'))
        @set('unitOfTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('unit'))
        # --- Humidity Threshold details ---
        @set('highHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('high'))
        @set('lowHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('low'))
        @set('unitOfHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('unit'))

        @set('_extractedAllWeatherAnalyticsSettings', true)

    _fillSvgElementWithBlackColour: (event) -> @attr({ fill: 'black' })

    _onClickIncrement_QualifierCount: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) + 1
        if digit > 12 then 1 else digit

    _onClickDecrement_QualifierCount: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < 1 then 12 else digit

    _onClickIncrement_DefaultTemperatureTrigger: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) + 1
        if digit > 9 then -15 else digit

    _onClickDecrement_DefaultTemperatureTrigger: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < -15 then 9 else digit

    _onClickIncrement_OnHighHumidityTemperatureTrigger: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) + 1
        if digit > 10 then -15 else digit

    _onClickDecrement_OnHighHumidityTemperatureTrigger: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < -15 then 10 else digit

    _onClickIncrement_HighHumidityThreshold: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) + 1
        if digit > 100 then 60 else digit

    _onClickDecrement_HighHumidityThreshold: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < 60 then 100 else digit

    _onClickIncrement_LowHumidityThreshold: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) + 1
        if digit > 70 then 0 else digit

    _onClickDecrement_LowHumidityThreshold: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < 0 then 70 else digit

    # -------------------------
    # --- Declare Observers ---
    # -------------------------
    onDTAQualifierCountChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @weatherAnalyticsSettings.downtrendanalyser.content[0].record.set('qualifierCount', @dtaQualifierCount)
            @weatherAnalyticsSettings.downtrendanalyser.content[0].save()
    ).observes('dtaQualifierCount')

    onDefaultTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_default_TemperatureTrigger_SvgObj.node.textContent = @defaultTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('default', @defaultTemperatureTrigger)
            @weatherAnalyticsSettings.temperaturetrigger.content[0].save().then( (->
                if parseInt(@defaultTemperatureTrigger, 10) > parseInt(@onHighHumidityTemperatureTrigger, 10)
                    @set('onHighHumidityTemperatureTrigger', @defaultTemperatureTrigger)
            ).bind(@))
    ).observes('defaultTemperatureTrigger')

    onHighHumidityTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_onHighHumidity_TemperatureTrigger_SvgObj.node.textContent = @onHighHumidityTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('onHighHumidity', @onHighHumidityTemperatureTrigger)
            @weatherAnalyticsSettings.temperaturetrigger.content[0].save().then( (->
                if parseInt(@onHighHumidityTemperatureTrigger, 10) < parseInt(@defaultTemperatureTrigger, 10)
                    @set('defaultTemperatureTrigger', @onHighHumidityTemperatureTrigger)
            ).bind(@))
    ).observes('onHighHumidityTemperatureTrigger')

    onHighHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_high_HumidityThershold_SvgObj.node.textContent = @high_HumidityThershold
            @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('high', @high_HumidityThershold)
            @weatherAnalyticsSettings.humiditythreshold.content[0].save().then( (->
                if parseInt(@high_HumidityThershold, 10) < parseInt(@low_HumidityThershold, 10)
                    @set('low_HumidityThershold', @high_HumidityThershold)
            ).bind(@))
    ).observes('high_HumidityThershold')

    onLowHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_low_HumidityThershold_SvgObj.node.textContent = @low_HumidityThershold
            @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('low', @low_HumidityThershold)
            @weatherAnalyticsSettings.humiditythreshold.content[0].save().then( (->
                if parseInt(@low_HumidityThershold, 10) > parseInt(@high_HumidityThershold, 10)
                    @set('high_HumidityThershold', @low_HumidityThershold)
            ).bind(@))
    ).observes('low_HumidityThershold')
)

`export default WeatherAnalyticsSettingsComponent`
