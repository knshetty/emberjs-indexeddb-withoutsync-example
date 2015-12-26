`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'downtrend-settings', 'Integration | Component | downtrend settings', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{downtrend-settings}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#downtrend-settings}}
      template block text
    {{/downtrend-settings}}
  """

  assert.equal @$().text().trim(), 'template block text'
