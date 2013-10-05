$ ->

  $('[data-toggle=popover]').each ->
    popoverShown = false
    $btn = $(@)
    $contents = $btn.next('.popover-content-box').hide().children()
    $btn.popover(trigger: 'manual')

    hidePopover = ->
      $btn.popover('hide')
      popoverShown = false

    showPopover = ->
      $btn.popover('show')
      $contents.appendTo($btn.data('bs.popover').$tip.find('.popover-content'))
      popoverShown = true

      $('.btn-close', $contents).off('click').click ->
        hidePopover()

      $('.btn-insert', $contents).off('click').click ->
        chord = '[' + $('.active', $contents).text().replace(/([^0-9A-Za-z\/\#])/g, "") + ']'
        window.editor.$editor.insertAtCaret(chord)
        window.editor.$editor.focus()
        window.previewer.update()
        hidePopover()

    $btn.click (e) ->
      if popoverShown
        hidePopover()
      else
        showPopover()


  $('input[type=slider]').slider()
