`import Ember from 'ember'`

HumidityThresholdSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ------------------------
    # --- Declare: Globals ---
    # ------------------------
    _isExtracted_HumidityThresholdSettings: false

    _settingsBox_Line_DefaultColour: '#808080'
    _settingsBox_Line_DefaultOpacity: 1.0
    _settingsBox_Line_OnChangeColour: '#bc2122'
    _settingsBox_Line_OnChangeOpacity: 0.75

    _high_HumidityThershold_SvgObj: null
    _boxNpole_High_HumidityThershold_SvgObj: null
    _savebutton_High_HumidityThershold_SvgObj: null
    _low_HumidityThershold_SvgObj: null
    _boxNpole_Low_HumidityThershold_SvgObj: null
    _savebutton_Low_HumidityThershold_SvgObj: null

    _highHumidityThreshold: null
    _lowHumidityThreshold: null
    _unitOfHumidityThreshold: null

    # ---------------------------------------------
    # --- Declare: Component Specific Functions ---
    # ---------------------------------------------
    didInsertElement: ->

        # Create snap.svg context
        @_snapsvgInit()

        # Get handle to Humidity-Threshold svg
        s = @get('draw')

        # Manipulate Humidity-Threshold svg objects
        Snap.load('assets/humidity_threshold_settings.svg', ((f) ->

            # Extract data from model
            @_extractWeatherAnalyticsSettingsDataset()

            arrowButtonColour_Default = '#808080'

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
      draw = Snap('#humiditythreshold-weatheranalytics-settings-wrapper')
      @set('draw', draw)

    _extractWeatherAnalyticsSettingsDataset: ->
      # --- Get/Set Humidity Threshold details ---
      @set('_highHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('high'))
      @set('_lowHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('low'))
      @set('_unitOfHumidityThreshold', @weatherAnalyticsSettings.humiditythreshold.content[0].record.get('unit'))

      @set('_isExtracted_HumidityThresholdSettings', true)

    _fillSvgElementWithBlackColour: (event) -> @attr({ fill: 'black' })

    _fadeSvgElement: (event) -> @attr({ opacity: 0.9 })

    _UnfadeSvgElement: (event) -> @attr({ opacity: 1 })

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
    onHighHumidityThresholdChanged: ( ->
        if @_isExtracted_HumidityThresholdSettings
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
        if @_isExtracted_HumidityThresholdSettings
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

`export default HumidityThresholdSettingsComponent`
