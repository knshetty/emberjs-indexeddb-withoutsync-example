`import Ember from 'ember'`

TemperatureTriggerSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ------------------------
    # --- Declare: Globals ---
    # ------------------------
    _isExtracted_TemperatureTriggerSettings: false

    _settingsBox_Line_DefaultColour: '#808080'
    _settingsBox_Line_DefaultOpacity: 1.0
    _settingsBox_Line_OnChangeColour: '#bc2122'
    _settingsBox_Line_OnChangeOpacity: 0.75

    _default_TemperatureTrigger_SvgObj: null
    _onHighHumidity_TemperatureTrigger_SvgObj: null
    _boxNpole_TemperatureTrigger_SvgObj: null
    _savebutton_TemperatureTrigger_SvgObj: null

    _defaultTemperatureTrigger: null
    _onHighHumidityTemperatureTrigger: null
    _unitOfTemperatureTrigger: null

    # ---------------------------------------------
    # --- Declare: Component Specific Functions ---
    # ---------------------------------------------
    didInsertElement: ->

        # Create snap.svg context
        @_snapsvgInit()

        # Get handle to Temperature-Trigger svg
        s = @get('draw')

        # Manipulate Temperature-Trigger svg objects
        Snap.load('assets/temperature_trigger_settings.svg', ((f) ->

            # Extract data from model
            @_extractWeatherAnalyticsSettingsDataset()

            arrowButtonColour_Default = '#808080'

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
            savebutton_TemperatureTrigger.click( ( ->
              @weatherAnalyticsSettings.temperaturetrigger.content[0].save().then( ( ->
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

            s.append(f)

        ).bind(@))

    # --------------------------------
    # --- Declare: Local Functions ---
    # --------------------------------
    _snapsvgInit: ->
      draw = Snap('#temperaturetrigger-weatheranalytics-settings-wrapper')
      @set('draw', draw)

    _extractWeatherAnalyticsSettingsDataset: ->
      # --- Get/Set Temperature Trigger details ---
      @set('_defaultTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('default'))
      @set('_onHighHumidityTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('onHighHumidity'))
      @set('_unitOfTemperatureTrigger', @weatherAnalyticsSettings.temperaturetrigger.content[0].record.get('unit'))

      @set('_isExtracted_TemperatureTriggerSettings', true)

    _fillSvgElementWithBlackColour: (event) -> @attr({ fill: 'black' })

    _fadeSvgElement: (event) -> @attr({ opacity: 0.9 })

    _UnfadeSvgElement: (event) -> @attr({ opacity: 1 })

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

    _setColourToDefault_SettingsBox: (svgElement) ->
      svgElement.attr('stroke', @_settingsBox_Line_DefaultColour)
      svgElement.attr('opacity', @_settingsBox_Line_DefaultOpacity)

    _setColourToOnChange_SettingsBox: (svgElement) ->
      svgElement.attr('stroke', @_settingsBox_Line_OnChangeColour)
      svgElement.attr('opacity', @_settingsBox_Line_OnChangeOpacity)


    # -------------------------
    # --- Declare Observers ---
    # -------------------------
    onDefaultTemperatureTriggerChanged: ( ->
        if @_isExtracted_TemperatureTriggerSettings
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
        if @_isExtracted_TemperatureTriggerSettings
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
)

`export default TemperatureTriggerSettingsComponent`
