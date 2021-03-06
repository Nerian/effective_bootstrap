# This initializes all the effective_* form inputs also in this gem
this.EffectiveBootstrap ||= new class
  initialize: (target) ->
    $(target || document).find('[data-input-js-options]:not(.initialized)').each (i, element) ->
      $element = $(element)
      options = $element.data('input-js-options')

      method_name = options['method_name']
      delete options['method_name']

      unless EffectiveBootstrap[method_name]
        return console.error("EffectiveBootstrap #{method_name} has not been implemented")

      EffectiveBootstrap[method_name].call(this, $element, options)
      $element.addClass('initialized')

$ -> EffectiveBootstrap.initialize()
$(document).on 'turbolinks:load', -> EffectiveBootstrap.initialize()
$(document).on 'cocoon:after-insert', -> EffectiveBootstrap.initialize()
$(document).on 'effective-bootstrap:initialize', (event) -> EffectiveBootstrap.initialize(event.currentTarget)

# These next three methods hijack jquery_ujs data-confirm and do it our own way with a double click confirm
$(document).on 'confirm', (event) ->
  $obj = $(event.target)

  if $obj.data('confirmed')
    true
  else
    $obj.data('confirm-original', $obj.html())
    $obj.html($obj.data('confirm'))
    $obj.data('confirmed', true)
    setTimeout(
      (->
        $obj.data('confirmed', false)
        $obj.html($obj.data('confirm-original'))
      )
      , 4000)
    false # don't show the confirmation dialog

$.rails.confirm = (message) -> true if $.rails
$(document).on 'confirm:complete', (event) -> $(event.target).data('confirmed')

# Fade out cocoon remove.
$(document).on 'cocoon:before-remove', (event, $obj) ->
  $(event.target).data('remove-timeout', 1000)
  $obj.fadeOut('slow')
