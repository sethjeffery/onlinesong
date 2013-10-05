class Editor
  $editor: null
  $fontUp: null
  $fontDown: null

  fontSize: 14

  init: ->
    @$editor = $('#editor')
    @$fontUp = $('#editor-font-up')
    @$fontDown = $('#editor-font-down')
    @bindToolbarButtons()
    @updateFontSize()
    @updateDownloadButton()
    @$editor.focus()

    @$editor.on 'keyup', =>
      window.previewer.update()
      @updateDownloadButton()

  bindToolbarButtons: ->
    @$fontUp.click =>
      @fontSize+=2
      @updateFontSize()

    @$fontDown.click =>
      @fontSize-=2
      @updateFontSize()

  updateFontSize: ->
    @$editor.css(fontSize: @fontSize + 'px')
    if @fontSize <= 10 then @$fontDown.attr('disabled', 'disabled') else @$fontDown.removeAttr('disabled')
    if @fontSize >= 20 then @$fontUp.attr('disabled', 'disabled') else @$fontUp.removeAttr('disabled')

  updateDownloadButton: ->
    if @$editor.val().length > 0
      $('#download_menu_item').show()
    else
      $('#download_menu_item').hide()


$ =>
  @editor = new Editor()
  @editor.init()

