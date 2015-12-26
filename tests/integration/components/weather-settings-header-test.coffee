`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'weather-settings-header', 'Integration | Component | weather settings header', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{weather-settings-header}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#weather-settings-header}}
      template block text
    {{/weather-settings-header}}
  """

  assert.equal @$().text().trim(), 'template block text'
