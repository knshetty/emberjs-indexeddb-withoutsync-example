`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'temperature-trigger-settings', 'Integration | Component | temperature trigger settings', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{temperature-trigger-settings}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#temperature-trigger-settings}}
      template block text
    {{/temperature-trigger-settings}}
  """

  assert.equal @$().text().trim(), 'template block text'
