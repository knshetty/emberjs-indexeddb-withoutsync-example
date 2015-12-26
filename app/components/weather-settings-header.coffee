`import Ember from 'ember'`

WeatherSettingsHeaderComponent = Ember.Component.extend(

  # ---------------------------------------------
  # --- Declare: Component Specific Functions ---
  # ---------------------------------------------
  didInsertElement: ->
    # Create snap.svg context
    @_snapsvgInit()

    # Get handle to Sun svg as the header
    s = @get('draw')

    # Manipulate Sun svg objects
    Snap.load('assets/sun.svg', ((f) ->
      s.append(f)
    ).bind(@))

# --------------------------------
# --- Declare: Local Functions ---
# --------------------------------
_snapsvgInit: ->
  draw = Snap('#header-weatheranalytics-settings-wrapper')
  @set('draw', draw)

)

`export default WeatherSettingsHeaderComponent`
