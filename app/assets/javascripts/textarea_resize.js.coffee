$ ->
  $editor = $('#editor')
  $previewer = $('#previewer')
  $browser = $('#browser > .file-list')

  resizeEditor = ->
    height = $(window).height()

    offset = $editor.offset()
    $editor.css height: height - offset.top

    offset = $previewer.offset()
    $previewer.css height: height - offset.top

    offset = $browser.offset()
    $browser.css height: height - offset.top

  $( window ).resize(resizeEditor);
  $( '#open_dropbox' ).on 'click', ->
    setTimeout ->
      resizeEditor()
    , 100

  resizeEditor();
