`import Ember from 'ember'`

WeatherAnalyticsSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ----------------
    # Declare: Globals
    # ----------------
    _extractedAllWeatherAnalyticsSettings: false

    _boxAndpoleColour_Default: '#808080'
    _boxAndpoleOpacity_Default: 1.0
    _boxAndpoleColour_OnChange: '#bc2122'
    _boxAndpoleOpacity_OnChange: 0.75

    _boxNpole_QualifierCountDTA_SvgObj: null
    _savebutton_QualifierCountDTA_SvgObj: null

    _default_TemperatureTrigger_SvgObj: null
    _onHighHumidity_TemperatureTrigger_SvgObj: null
    _boxNpole_TemperatureTrigger_SvgObj: null
    _savebutton_TemperatureTrigger_SvgObj: null

    _high_HumidityThershold_SvgObj: null
    _boxNpole_High_HumidityThershold_SvgObj: null
    _savebutton_High_HumidityThershold_SvgObj: null
    _low_HumidityThershold_SvgObj: null
    _boxNpole_Low_HumidityThershold_SvgObj: null
    _savebutton_Low_HumidityThershold_SvgObj: null

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
            @_extractWeatherAnalyticsSettingsDataset()

            arrowButtonColour_Default = '#808080'

            # ---------------------------
            # --- Down-Trend Analyser ---
            # ---------------------------
            # Get all related svg objects
            qualifierCount_DTA = f.select('#qualifier_count_dta')
            unit_QualifierCount_DTA = f.select('#unit_qualifier_count_dta')
            upArrow_QualifierCount_DTA = f.select('#uparrow_qualifier_count_dta')
            downArrow_QualifierCount_DTA = f.select('#downarrow_qualifier_count_dta')
            boxNpole_QualifierCount_DTA = f.select('#boxNpole_qualifier_count_dta')
            savebutton_QualifierCount_DTA = f.select('#savebutton_qualifier_count_dta')

            # Initialise digit & unit
            qualifierCount_DTA.node.textContent = @dtaQualifierCount
            unit_QualifierCount_DTA.node.textContent = @dtaUnitOfQualifierCount

            # Digit-Increment handler
            upArrow_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_QualifierCount_DTA.mouseup( ( ->
                upArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickIncrement_QualifierCount(qualifierCount_DTA)
                @set('dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # Digit-Decrement handler
            downArrow_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_QualifierCount_DTA.mouseup( ( ->
                downArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickDecrement_QualifierCount(qualifierCount_DTA)
                @set('dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # --- Box-And-Pole + Save-Button -----------------------------------
            @set('_boxNpole_QualifierCountDTA_SvgObj', boxNpole_QualifierCount_DTA)
            # Save-Button interactivity & event-handler
            savebutton_QualifierCount_DTA.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_QualifierCount_DTA.click(( ->
                @weatherAnalyticsSettings.downtrendanalyser.content[0].save().then( (->

                    box = boxNpole_QualifierCount_DTA.select('#box_qualifier_count_dta')
                    box.attr('stroke', @_boxAndpoleColour_Default)
                    box.attr('opacity', @_boxAndpoleOpacity_Default)

                    pole = boxNpole_QualifierCount_DTA.select('#pole_qualifier_count_dta')
                    pole.attr('stroke', @_boxAndpoleColour_Default)
                    pole.attr('opacity', @_boxAndpoleOpacity_Default)

                    savebutton_QualifierCount_DTA.attr({ visibility: 'hidden' })

                ).bind(@))
            ).bind(@))
            @set('_savebutton_QualifierCountDTA_SvgObj', savebutton_QualifierCount_DTA)

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

            boxesNpole_TemperatureTrigger = f.select('#boxNpole_temperaturetrigger')
            savebutton_TemperatureTrigger = f.select('#savebutton_temperaturetrigger')

            # Initialise digit & unit
            default_TemperatureTrigger.node.textContent = @defaultTemperatureTrigger
            unit_Default_TemperatureTrigger.node.textContent = @unitOfTemperatureTrigger

            onHighHumidity_TemperatureTrigger.node.textContent = @onHighHumidityTemperatureTrigger
            unit_OnHighHumidity_TemperatureTrigger.node.textContent = @unitOfTemperatureTrigger

            # Digit-Increment handlers
            upArrow_Default_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Default_TemperatureTrigger.mouseup( ( ->
                upArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('defaultTemperatureTrigger', @_onClickIncrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            upArrow_OnHighHumidity_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                upArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('onHighHumidityTemperatureTrigger', @_onClickIncrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_Default_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Default_TemperatureTrigger.mouseup( ( ->
                downArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('defaultTemperatureTrigger', @_onClickDecrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            downArrow_OnHighHumidity_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                downArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('onHighHumidityTemperatureTrigger', @_onClickDecrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # --- Box-And-Pole + Save-Button -----------------------------------
            @set('_boxNpole_TemperatureTrigger_SvgObj', boxesNpole_TemperatureTrigger)

            # Save-Button interactivity & event-handler
            savebutton_TemperatureTrigger.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_TemperatureTrigger.click( (->
              @weatherAnalyticsSettings.temperaturetrigger.content[0].save().then( (->

                box = boxesNpole_TemperatureTrigger.select('#box_default_temperaturetrigger')
                box.attr('stroke', @_boxAndpoleColour_Default)
                box.attr('opacity', @_boxAndpoleOpacity_Default)

                box = boxesNpole_TemperatureTrigger.select('#box_onhighhumidity_temperaturetrigger')
                box.attr('stroke', @_boxAndpoleColour_Default)
                box.attr('opacity', @_boxAndpoleOpacity_Default)

                pole = boxesNpole_TemperatureTrigger.select('#pole_temperaturetrigger')
                pole.attr('stroke', @_boxAndpoleColour_Default)
                pole.attr('opacity', @_boxAndpoleOpacity_Default)

                savebutton_TemperatureTrigger.attr({ visibility: 'hidden' })

              ).bind(@))
            ).bind(@))
            @set('_savebutton_TemperatureTrigger_SvgObj', savebutton_TemperatureTrigger)

            # --------------------------
            # --- Humidity Threshold ---
            # --------------------------
            # Get all related svg objects
            high_HumidityThershold = f.select('#high_humiditythershold')
            @set('_high_HumidityThershold_SvgObj', high_HumidityThershold)
            unit_High_HumidityThershold = f.select('#unit_high_humiditythershold')
            upArrow_High_HumidityThershold = f.select('#uparrow_high_humiditythershold')
            downArrow_High_HumidityThershold = f.select('#downarrow_high_humiditythershold')
            boxNpole_High_HumidityThershold = f.select('#boxNpole_high_humiditythershold')
            savebutton_High_HumidityThershold = f.select('#savebutton_high_humiditythershold')

            low_HumidityThershold = f.select('#low_humiditythershold')
            @set('_low_HumidityThershold_SvgObj', low_HumidityThershold)
            unit_Low_HumidityThershold = f.select('#unit_low_humiditythershold')
            upArrow_Low_HumidityThershold = f.select('#uparrow_low_humiditythershold')
            downArrow_Low_HumidityThershold = f.select('#downarrow_low_humiditythershold')
            boxNpole_Low_HumidityThershold = f.select('#boxNpole_low_humiditythershold')
            savebutton_Low_HumidityThershold = f.select('#savebutton_low_humiditythershold')

            # Initialise digit & unit
            high_HumidityThershold.node.textContent = @highHumidityThreshold
            unit_High_HumidityThershold.node.textContent = @unitOfHumidityThreshold

            low_HumidityThershold.node.textContent = @lowHumidityThreshold
            unit_Low_HumidityThershold.node.textContent = @unitOfHumidityThreshold

            # Digit-Increment handlers
            upArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_High_HumidityThershold.mouseup( ( ->
                upArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('highHumidityThreshold', @_onClickIncrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            upArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Low_HumidityThershold.mouseup( ( ->
                upArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('lowHumidityThreshold', @_onClickIncrement_LowHumidityThreshold(low_HumidityThershold))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_High_HumidityThershold.mouseup( ( ->
                downArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('highHumidityThreshold', @_onClickDecrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            downArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Low_HumidityThershold.mouseup( ( ->
                downArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('lowHumidityThreshold', @_onClickDecrement_LowHumidityThreshold(low_HumidityThershold))
            ).bind(@))

            # --- Box-And-Pole + Save-Button -----------------------------------
            @set('_boxNpole_High_HumidityThershold_SvgObj', boxNpole_High_HumidityThershold)
            @set('_boxNpole_Low_HumidityThershold_SvgObj', boxNpole_Low_HumidityThershold)

            # Save-Button interactivity & event-handler
            savebutton_High_HumidityThershold.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_High_HumidityThershold.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_High_HumidityThershold.click( (->
              @weatherAnalyticsSettings.humiditythreshold.content[0].save().then( (->

                box = boxNpole_High_HumidityThershold.select('#box_high_humiditythershold')
                box.attr('stroke', @_boxAndpoleColour_Default)
                box.attr('opacity', @_boxAndpoleOpacity_Default)

                pole = boxNpole_High_HumidityThershold.select('#pole_high_humiditythershold')
                pole.attr('stroke', @_boxAndpoleColour_Default)
                pole.attr('opacity', @_boxAndpoleOpacity_Default)

                savebutton_High_HumidityThershold.attr({ visibility: 'hidden' })

              ).bind(@))
            ).bind(@))
            @set('_savebutton_High_HumidityThershold_SvgObj', savebutton_High_HumidityThershold)

            savebutton_Low_HumidityThershold.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_Low_HumidityThershold.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_Low_HumidityThershold.click( (->
              @weatherAnalyticsSettings.humiditythreshold.content[0].save().then( (->

                box = boxNpole_Low_HumidityThershold.select('#box_low_humiditythershold')
                box.attr('stroke', @_boxAndpoleColour_Default)
                box.attr('opacity', @_boxAndpoleOpacity_Default)

                pole = boxNpole_Low_HumidityThershold.select('#pole_low_humiditythershold')
                pole.attr('stroke', @_boxAndpoleColour_Default)
                pole.attr('opacity', @_boxAndpoleOpacity_Default)

                savebutton_Low_HumidityThershold.attr({ visibility: 'hidden' })

              ).bind(@))
            ).bind(@))
            @set('_savebutton_Low_HumidityThershold_SvgObj', savebutton_Low_HumidityThershold)

            s.append(f)

        ).bind(@))

    # ------------------------
    # Declare: Local Functions
    # ------------------------
    _snapsvgInit: ->
        draw = Snap('#weather-analytics-settings-wrapper')
        @set('draw', draw)

    _extractWeatherAnalyticsSettingsDataset: ->
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

    _fadeSvgElement: (event) -> @attr({ opacity: 0.9 })

    _UnfadeSvgElement: (event) -> @attr({ opacity: 1 })

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
        if digit > 34 then 0 else digit

    _onClickDecrement_LowHumidityThreshold: (svgDigitElement) ->
        digit = parseInt(svgDigitElement.node.textContent, 10) - 1
        if digit < 0 then 34 else digit

    # -------------------------
    # --- Declare Observers ---
    # -------------------------
    onDTAQualifierCountChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @weatherAnalyticsSettings.downtrendanalyser.content[0].record.set('qualifierCount', @dtaQualifierCount)

            # --- Box-And-Pole ---
            box = @_boxNpole_QualifierCountDTA_SvgObj.select('#box_qualifier_count_dta')
            pole = @_boxNpole_QualifierCountDTA_SvgObj.select('#pole_qualifier_count_dta')
            box.attr('stroke', @_boxAndpoleColour_OnChange)
            box.attr('opacity', @_boxAndpoleOpacity_OnChange)
            pole.attr('stroke', @_boxAndpoleColour_OnChange)
            pole.attr('opacity', @_boxAndpoleOpacity_OnChange)

            # --- Save Button ---
            @_savebutton_QualifierCountDTA_SvgObj.attr({ visibility:'visible' })
            #@weatherAnalyticsSettings.downtrendanalyser.content[0].save()
    ).observes('dtaQualifierCount')

    onDefaultTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_default_TemperatureTrigger_SvgObj.node.textContent = @defaultTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('default', @defaultTemperatureTrigger)

            # --- Box-And-Pole ---
            box = @_boxNpole_TemperatureTrigger_SvgObj.select('#box_default_temperaturetrigger')
            pole = @_boxNpole_TemperatureTrigger_SvgObj.select('#pole_temperaturetrigger')
            box.attr('stroke', @_boxAndpoleColour_OnChange)
            box.attr('opacity', @_boxAndpoleOpacity_OnChange)
            pole.attr('stroke', @_boxAndpoleColour_OnChange)
            pole.attr('opacity', @_boxAndpoleOpacity_OnChange)

            # --- Save Button ---
            @_savebutton_TemperatureTrigger_SvgObj.attr({ visibility:'visible' })

            # --- Sanity Checking & Imposed Correction between Default/High-Humidity Temperature Triggers ---
            if parseInt(@defaultTemperatureTrigger, 10) > parseInt(@onHighHumidityTemperatureTrigger, 10)
                @set('onHighHumidityTemperatureTrigger', @defaultTemperatureTrigger)

    ).observes('defaultTemperatureTrigger')

    onHighHumidityTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_onHighHumidity_TemperatureTrigger_SvgObj.node.textContent = @onHighHumidityTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('onHighHumidity', @onHighHumidityTemperatureTrigger)

            # --- Box-And-Pole ---
            box = @_boxNpole_TemperatureTrigger_SvgObj.select('#box_onhighhumidity_temperaturetrigger')
            pole = @_boxNpole_TemperatureTrigger_SvgObj.select('#pole_temperaturetrigger')
            box.attr('stroke', @_boxAndpoleColour_OnChange)
            box.attr('opacity', @_boxAndpoleOpacity_OnChange)
            pole.attr('stroke', @_boxAndpoleColour_OnChange)
            pole.attr('opacity', @_boxAndpoleOpacity_OnChange)

            # --- Save Button ---
            @_savebutton_TemperatureTrigger_SvgObj.attr({ visibility:'visible' })

            # --- Sanity Checking & Imposed Correction between Default/High-Humidity Temperature Triggers ---
            if parseInt(@onHighHumidityTemperatureTrigger, 10) < parseInt(@defaultTemperatureTrigger, 10)
                @set('defaultTemperatureTrigger', @onHighHumidityTemperatureTrigger)

    ).observes('onHighHumidityTemperatureTrigger')

    onHighHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
          @_high_HumidityThershold_SvgObj.node.textContent = @highHumidityThreshold
          @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('high', @highHumidityThreshold)

          # --- Box-And-Pole ---
          box = @_boxNpole_High_HumidityThershold_SvgObj.select('#box_high_humiditythershold')
          pole = @_boxNpole_High_HumidityThershold_SvgObj.select('#pole_high_humiditythershold')
          box.attr('stroke', @_boxAndpoleColour_OnChange)
          box.attr('opacity', @_boxAndpoleOpacity_OnChange)
          pole.attr('stroke', @_boxAndpoleColour_OnChange)
          pole.attr('opacity', @_boxAndpoleOpacity_OnChange)

          # --- Save Button ---
          @_savebutton_High_HumidityThershold_SvgObj.attr({ visibility:'visible' })
    ).observes('highHumidityThreshold')

    onLowHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_low_HumidityThershold_SvgObj.node.textContent = @lowHumidityThreshold
            @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('low', @lowHumidityThreshold)

            # --- Box-And-Pole ---
            box = @_boxNpole_Low_HumidityThershold_SvgObj.select('#box_low_humiditythershold')
            pole = @_boxNpole_Low_HumidityThershold_SvgObj.select('#pole_low_humiditythershold')
            box.attr('stroke', @_boxAndpoleColour_OnChange)
            box.attr('opacity', @_boxAndpoleOpacity_OnChange)
            pole.attr('stroke', @_boxAndpoleColour_OnChange)
            pole.attr('opacity', @_boxAndpoleOpacity_OnChange)

            # --- Save Button ---
            @_savebutton_Low_HumidityThershold_SvgObj.attr({ visibility:'visible' })
    ).observes('lowHumidityThreshold')
)

`export default WeatherAnalyticsSettingsComponent`
