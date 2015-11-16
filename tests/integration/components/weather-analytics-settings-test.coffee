`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'weather-analytics-settings', 'Integration | Component | weather analytics settings', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{weather-analytics-settings}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#weather-analytics-settings}}
      template block text
    {{/weather-analytics-settings}}
  """

  assert.equal @$().text().trim(), 'template block text'
