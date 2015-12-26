`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'humidity-threshold-settings', 'Integration | Component | humidity threshold settings', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{humidity-threshold-settings}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#humidity-threshold-settings}}
      template block text
    {{/humidity-threshold-settings}}
  """

  assert.equal @$().text().trim(), 'template block text'
