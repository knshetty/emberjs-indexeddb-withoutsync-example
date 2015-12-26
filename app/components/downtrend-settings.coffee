`import Ember from 'ember'`

DowntrendSettingsComponent = Ember.Component.extend(

    attributeBindings: ['weatherAnalyticsSettings']

    # ------------------------
    # --- Declare: Globals ---
    # ------------------------
    _isExtracted_DownTrendSettings: false

    _settingsBox_Line_DefaultColour: '#808080'
    _settingsBox_Line_DefaultOpacity: 1.0
    _settingsBox_Line_OnChangeColour: '#bc2122'
    _settingsBox_Line_OnChangeOpacity: 0.75

    _boxNpole_QualifierCountDTA_SvgObj: null
    _savebutton_QualifierCountDTA_SvgObj: null

    _dtaQualifierCount: null
    _dtaUnitOfQualifierCount: null

    # ---------------------------------------------
    # --- Declare: Component Specific Functions ---
    # ---------------------------------------------
    didInsertElement: ->

        # Create snap.svg context
        @_snapsvgInit()

        # Get handle to downtrend-settings svg
        s = @get('draw')

        # Manipulate downtrend-settings svg objects
        Snap.load('assets/downtrend_settings.svg', ((f) ->

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

            s.append(f)

        ).bind(@))

    # --------------------------------
    # --- Declare: Local Functions ---
    # --------------------------------
    _snapsvgInit: ->
      draw = Snap('#downtrend-weatheranalytics-settings-wrapper')
      @set('draw', draw)

    _extractWeatherAnalyticsSettingsDataset: ->
      # --- Get/Set Down-Trend Analyser details ---
      @set('_dtaQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('qualifierCount'))
      @set('_dtaUnitOfQualifierCount', @weatherAnalyticsSettings.downtrendanalyser.content[0].record.get('unit'))
      @set('_isExtracted_DownTrendSettings', true)

    _fillSvgElementWithBlackColour: (event) -> @attr({ fill: 'black' })

    _fadeSvgElement: (event) -> @attr({ opacity: 0.9 })

    _UnfadeSvgElement: (event) -> @attr({ opacity: 1 })

    _onClickIncrement_QualifierCount: (svgDigitElement) ->
      digit = parseInt(svgDigitElement.node.textContent, 10) + 1
      if digit > 12 then 1 else digit

    _onClickDecrement_QualifierCount: (svgDigitElement) ->
      digit = parseInt(svgDigitElement.node.textContent, 10) - 1
      if digit < 1 then 12 else digit

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

        if @_isExtracted_DownTrendSettings

            @weatherAnalyticsSettings.downtrendanalyser.content[0].record.set('qualifierCount', @_dtaQualifierCount)

            # --- Box-And-Pole ---
            box = @_boxNpole_QualifierCountDTA_SvgObj.select('#box_qualifier_count_dta')
            @_setColourToOnChange_SettingsBox(box)
            pole = @_boxNpole_QualifierCountDTA_SvgObj.select('#pole_qualifier_count_dta')
            @_setColourToOnChange_SettingsBox(pole)

            # --- Save Button ---
            @_savebutton_QualifierCountDTA_SvgObj.attr({ visibility:'visible' })

    ).observes('_dtaQualifierCount')

)

`export default DowntrendSettingsComponent`
