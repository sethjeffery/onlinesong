class Downloader
  $download: null

  initialize: ->
    @$download = $('#download')
    @$download.click (e) =>
      e.preventDefault()
      @download()

  download: ->
    $form = $("#editor_form")
    $form.submit()

$ =>
  @downloader = new Downloader()
  @downloader.initialize()
