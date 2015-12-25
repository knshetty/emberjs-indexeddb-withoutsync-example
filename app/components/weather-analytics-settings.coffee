`import Ember from 'ember'`

WeatherAnalyticsSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ------------------------
    # --- Declare: Globals ---
    # ------------------------
    _extractedAllWeatherAnalyticsSettings: false

    _settingsBox_Line_DefaultColour: '#808080'
    _settingsBox_Line_DefaultOpacity: 1.0
    _settingsBox_Line_OnChangeColour: '#bc2122'
    _settingsBox_Line_OnChangeOpacity: 0.75

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

    _dtaQualifierCount: null
    _dtaUnitOfQualifierCount: null

    _defaultTemperatureTrigger: null
    _onHighHumidityTemperatureTrigger: null
    _unitOfTemperatureTrigger: null

    _highHumidityThreshold: null
    _lowHumidityThreshold: null
    _unitOfHumidityThreshold: null

    # ---------------------------------------------
    # --- Declare: Component Specific Functions ---
    # ---------------------------------------------
    didInsertElement: ->

        # Create snap.svg context
        @_snapsvgInit()

        # Get handle to Weather svg
        s = @get('draw')

        # Manipulate Weather svg objects
        Snap.load('assets/weather.svg', ((f) ->

            # Extract data from model
            @_extractWeatherAnalyticsSettingsDataset()

            arrowButtonColour_Default = '#808080'

            # -------------------
            # Down-Trend Analyser
            # -------------------
            # Get all related svg objects
            qualifierCount_DTA = f.select('#qualifier_count_dta')
            unit_QualifierCount_DTA = f.select('#unit_qualifier_count_dta')
            upArrow_QualifierCount_DTA = f.select('#uparrow_qualifier_count_dta')
            downArrow_QualifierCount_DTA = f.select('#downarrow_qualifier_count_dta')
            boxNpole_QualifierCount_DTA = f.select('#boxNpole_qualifier_count_dta')
            savebutton_QualifierCount_DTA = f.select('#savebutton_qualifier_count_dta')

            # Initialise digit & unit
            qualifierCount_DTA.node.textContent = @_dtaQualifierCount
            unit_QualifierCount_DTA.node.textContent = @_dtaUnitOfQualifierCount

            # Digit-Increment handler
            upArrow_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_QualifierCount_DTA.mouseup( ( ->
                upArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickIncrement_QualifierCount(qualifierCount_DTA)
                @set('_dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # Digit-Decrement handler
            downArrow_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_QualifierCount_DTA.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_QualifierCount_DTA.mouseup( ( ->
                downArrow_QualifierCount_DTA.attr('fill', arrowButtonColour_Default) # UX initative
                qualifierCount_DTA.node.textContent = @_onClickDecrement_QualifierCount(qualifierCount_DTA)
                @set('_dtaQualifierCount', qualifierCount_DTA.node.textContent)
            ).bind(@))

            # --- Box-And-Pole + Save-Button -----------------------------------
            @set('_boxNpole_QualifierCountDTA_SvgObj', boxNpole_QualifierCount_DTA)
            # Save-Button interactivity & event-handler
            savebutton_QualifierCount_DTA.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_QualifierCount_DTA.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_QualifierCount_DTA.click(( ->
                @weatherAnalyticsSettings.downtrendanalyser.content[0].save().then( (->
                    box = boxNpole_QualifierCount_DTA.select('#box_qualifier_count_dta')
                    @_setColourToDefault_SettingsBox(box)
                    pole = boxNpole_QualifierCount_DTA.select('#pole_qualifier_count_dta')
                    @_setColourToDefault_SettingsBox(pole)
                    savebutton_QualifierCount_DTA.attr({ visibility: 'hidden' })
                ).bind(@))
            ).bind(@))
            @set('_savebutton_QualifierCountDTA_SvgObj', savebutton_QualifierCount_DTA)

            # -------------------
            # Temperature Trigger
            # -------------------
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
            default_TemperatureTrigger.node.textContent = @_defaultTemperatureTrigger
            unit_Default_TemperatureTrigger.node.textContent = @_unitOfTemperatureTrigger

            onHighHumidity_TemperatureTrigger.node.textContent = @_onHighHumidityTemperatureTrigger
            unit_OnHighHumidity_TemperatureTrigger.node.textContent = @_unitOfTemperatureTrigger

            # Digit-Increment handlers
            upArrow_Default_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Default_TemperatureTrigger.mouseup( ( ->
                upArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_defaultTemperatureTrigger', @_onClickIncrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            upArrow_OnHighHumidity_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            upArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                upArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_onHighHumidityTemperatureTrigger', @_onClickIncrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_Default_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_Default_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Default_TemperatureTrigger.mouseup( ( ->
                downArrow_Default_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_defaultTemperatureTrigger', @_onClickDecrement_DefaultTemperatureTrigger(default_TemperatureTrigger))
            ).bind(@))

            downArrow_OnHighHumidity_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            downArrow_OnHighHumidity_TemperatureTrigger.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_OnHighHumidity_TemperatureTrigger.mouseup( ( ->
                downArrow_OnHighHumidity_TemperatureTrigger.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_onHighHumidityTemperatureTrigger', @_onClickDecrement_OnHighHumidityTemperatureTrigger(onHighHumidity_TemperatureTrigger))
            ).bind(@))

            # --- Box-And-Pole + Save-Button -----------------------------------
            @set('_boxNpole_TemperatureTrigger_SvgObj', boxesNpole_TemperatureTrigger)

            # Save-Button interactivity & event-handler
            savebutton_TemperatureTrigger.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_TemperatureTrigger.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_TemperatureTrigger.click( (->
              @weatherAnalyticsSettings.temperaturetrigger.content[0].save().then( (->
                box = boxesNpole_TemperatureTrigger.select('#box_default_temperaturetrigger')
                @_setColourToDefault_SettingsBox(box)
                box = boxesNpole_TemperatureTrigger.select('#box_onhighhumidity_temperaturetrigger')
                @_setColourToDefault_SettingsBox(box)
                pole = boxesNpole_TemperatureTrigger.select('#pole_temperaturetrigger')
                @_setColourToDefault_SettingsBox(pole)
                savebutton_TemperatureTrigger.attr({ visibility: 'hidden' })
              ).bind(@))
            ).bind(@))
            @set('_savebutton_TemperatureTrigger_SvgObj', savebutton_TemperatureTrigger)

            # ------------------
            # Humidity Threshold
            # ------------------
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
            high_HumidityThershold.node.textContent = @_highHumidityThreshold
            unit_High_HumidityThershold.node.textContent = @_unitOfHumidityThreshold

            low_HumidityThershold.node.textContent = @_lowHumidityThreshold
            unit_Low_HumidityThershold.node.textContent = @_unitOfHumidityThreshold

            # Digit-Increment handlers
            upArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_High_HumidityThershold.mouseup( ( ->
                upArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_highHumidityThreshold', @_onClickIncrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            upArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            upArrow_Low_HumidityThershold.mouseup( ( ->
                upArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_lowHumidityThreshold', @_onClickIncrement_LowHumidityThreshold(low_HumidityThershold))
            ).bind(@))

            # Digit-Decrement handlers
            downArrow_High_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_High_HumidityThershold.mouseup( ( ->
                downArrow_High_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_highHumidityThreshold', @_onClickDecrement_HighHumidityThreshold(high_HumidityThershold))
            ).bind(@))

            downArrow_Low_HumidityThershold.mousedown(@_fillSvgElementWithBlackColour) # UX initative
            downArrow_Low_HumidityThershold.mouseup( ( ->
                downArrow_Low_HumidityThershold.attr('fill', arrowButtonColour_Default) # UX initative
                @set('_lowHumidityThreshold', @_onClickDecrement_LowHumidityThreshold(low_HumidityThershold))
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
                @_setColourToDefault_SettingsBox(box)
                pole = boxNpole_High_HumidityThershold.select('#pole_high_humiditythershold')
                @_setColourToDefault_SettingsBox(pole)
                savebutton_High_HumidityThershold.attr({ visibility: 'hidden' })
              ).bind(@))
            ).bind(@))
            @set('_savebutton_High_HumidityThershold_SvgObj', savebutton_High_HumidityThershold)

            savebutton_Low_HumidityThershold.attr({ visibility: 'hidden' }) # Hide Button
            savebutton_Low_HumidityThershold.hover(@_fadeSvgElement, @_UnfadeSvgElement)
            savebutton_Low_HumidityThershold.click( (->
              @weatherAnalyticsSettings.humiditythreshold.content[0].save().then( (->
                box = boxNpole_Low_HumidityThershold.select('#box_low_humiditythershold')
                @_setColourToDefault_SettingsBox(box)
                pole = boxNpole_Low_HumidityThershold.select('#pole_low_humiditythershold')
                @_setColourToDefault_SettingsBox(pole)
                savebutton_Low_HumidityThershold.attr({ visibility: 'hidden' })
              ).bind(@))
            ).bind(@))
            @set('_savebutton_Low_HumidityThershold_SvgObj', savebutton_Low_HumidityThershold)

            s.append(f)

        ).bind(@))

    # --------------------------------
    # --- Declare: Local Functions ---
    # --------------------------------
    _snapsvgInit: ->
      draw = Snap('#weather-analytics-settings-wrapper')
      @set('draw', draw)

    _extractWeatherAnalyticsSettingsDataset: ->
      # --- Down-Trend Analyser details ---
      @set('_dtaQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('qualifierCount'))
      @set('_dtaUnitOfQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('unit'))
      # --- Temperature Trigger details ---
      @set('_defaultTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('default'))
      @set('_onHighHumidityTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('onHighHumidity'))
      @set('_unitOfTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('unit'))
      # --- Humidity Threshold details ---
      @set('_highHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('high'))
      @set('_lowHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('low'))
      @set('_unitOfHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('unit'))

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

    _setColourToDefault_SettingsBox: (svgElement) ->
      svgElement.attr('stroke', @_settingsBox_Line_DefaultColour)
      svgElement.attr('opacity', @_settingsBox_Line_DefaultOpacity)

    _setColourToOnChange_SettingsBox: (svgElement) ->
      svgElement.attr('stroke', @_settingsBox_Line_OnChangeColour)
      svgElement.attr('opacity', @_settingsBox_Line_OnChangeOpacity)


    # -------------------------
    # --- Declare Observers ---
    # -------------------------
    onDTAQualifierCountChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @weatherAnalyticsSettings.downtrendanalyser.content[0].record.set('qualifierCount', @_dtaQualifierCount)

            # --- Box-And-Pole ---
            box = @_boxNpole_QualifierCountDTA_SvgObj.select('#box_qualifier_count_dta')
            @_setColourToOnChange_SettingsBox(box)
            pole = @_boxNpole_QualifierCountDTA_SvgObj.select('#pole_qualifier_count_dta')
            @_setColourToOnChange_SettingsBox(pole)

            # --- Save Button ---
            @_savebutton_QualifierCountDTA_SvgObj.attr({ visibility:'visible' })
            #@weatherAnalyticsSettings.downtrendanalyser.content[0].save()
    ).observes('_dtaQualifierCount')

    onDefaultTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_default_TemperatureTrigger_SvgObj.node.textContent = @_defaultTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('default', @_defaultTemperatureTrigger)

            # --- Box-And-Pole ---
            box = @_boxNpole_TemperatureTrigger_SvgObj.select('#box_default_temperaturetrigger')
            @_setColourToOnChange_SettingsBox(box)
            pole = @_boxNpole_TemperatureTrigger_SvgObj.select('#pole_temperaturetrigger')
            @_setColourToOnChange_SettingsBox(pole)

            # --- Save Button ---
            @_savebutton_TemperatureTrigger_SvgObj.attr({ visibility:'visible' })

            # --- Sanity Checking & Imposed Correction between Default/High-Humidity Temperature Triggers ---
            if parseInt(@_defaultTemperatureTrigger, 10) > parseInt(@_onHighHumidityTemperatureTrigger, 10)
                @set('_onHighHumidityTemperatureTrigger', @_defaultTemperatureTrigger)

    ).observes('_defaultTemperatureTrigger')

    onHighHumidityTemperatureTriggerChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_onHighHumidity_TemperatureTrigger_SvgObj.node.textContent = @_onHighHumidityTemperatureTrigger
            @weatherAnalyticsSettings.temperaturetrigger.content[0].record.set('onHighHumidity', @_onHighHumidityTemperatureTrigger)

            # --- Box-And-Pole ---
            box = @_boxNpole_TemperatureTrigger_SvgObj.select('#box_onhighhumidity_temperaturetrigger')
            @_setColourToOnChange_SettingsBox(box)
            pole = @_boxNpole_TemperatureTrigger_SvgObj.select('#pole_temperaturetrigger')
            @_setColourToOnChange_SettingsBox(pole)

            # --- Save Button ---
            @_savebutton_TemperatureTrigger_SvgObj.attr({ visibility:'visible' })

            # --- Sanity Checking & Imposed Correction between Default/High-Humidity Temperature Triggers ---
            if parseInt(@_onHighHumidityTemperatureTrigger, 10) < parseInt(@_defaultTemperatureTrigger, 10)
                @set('_defaultTemperatureTrigger', @_onHighHumidityTemperatureTrigger)

    ).observes('_onHighHumidityTemperatureTrigger')

    onHighHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
          @_high_HumidityThershold_SvgObj.node.textContent = @_highHumidityThreshold
          @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('high', @_highHumidityThreshold)

          # --- Box-And-Pole ---
          box = @_boxNpole_High_HumidityThershold_SvgObj.select('#box_high_humiditythershold')
          @_setColourToOnChange_SettingsBox(box)
          pole = @_boxNpole_High_HumidityThershold_SvgObj.select('#pole_high_humiditythershold')
          @_setColourToOnChange_SettingsBox(pole)

          # --- Save Button ---
          @_savebutton_High_HumidityThershold_SvgObj.attr({ visibility:'visible' })
    ).observes('_highHumidityThreshold')

    onLowHumidityThresholdChanged: ( ->
        if @_extractedAllWeatherAnalyticsSettings
            @_low_HumidityThershold_SvgObj.node.textContent = @_lowHumidityThreshold
            @weatherAnalyticsSettings.humiditythreshold.content[0].record.set('low', @_lowHumidityThreshold)

            # --- Box-And-Pole ---
            box = @_boxNpole_Low_HumidityThershold_SvgObj.select('#box_low_humiditythershold')
            @_setColourToOnChange_SettingsBox(box)
            pole = @_boxNpole_Low_HumidityThershold_SvgObj.select('#pole_low_humiditythershold')
            @_setColourToOnChange_SettingsBox(pole)

            # --- Save Button ---
            @_savebutton_Low_HumidityThershold_SvgObj.attr({ visibility:'visible' })
    ).observes('_lowHumidityThreshold')
)

`export default WeatherAnalyticsSettingsComponent`
