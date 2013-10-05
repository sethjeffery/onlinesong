
class DropboxBrowser
  $view: null

  init: ->
    @$view = $('#browser')
    @browseTo '/'

  browseTo: (path) ->
    $.getJSON '/dropbox/browse' + path, (data) =>
      unless data.failed?
        @buildFolderName(data)
        @buildFileList(data.files)

  buildFolderName: (data) ->
    $folderName = @$view.children('.folder-name')
    $folderName.html('')

    if data.path != '/'
      $folderName.append($("<a class='btn btn-xs btn-default' href='#'><span class='glyphicon glyphicon-chevron-left'></span>#{data.human_name}</a>"))
    else
      $folderName.append("/ (root)")

    $folderName.click (e) =>
      e.preventDefault()
      e.stopPropagation()
      @browseTo(data.parent_path)

    return $folderName

  buildFileList: (files) ->
    view = @
    $fileList = @$view.children('.file-list')
    $fileList.children().remove()

    for f in files
      if f.type == 'folder'
        $fileList.append($("<li><a class='folder' href='#' data-path='#{f.path}'><span class='glyphicon glyphicon-folder-close'></span>#{f.human_name}</a></li>"))
      else
        $fileList.append($("<li><a class='file' href='#' data-path='#{f.path}'><span class='glyphicon glyphicon-file'></span>#{f.human_name}</a></li>"))

    $('a', $fileList).click (e) ->
      e.preventDefault()
      $this = $(@)

      if $this.hasClass('folder')
        e.stopPropagation()
        view.browseTo($this.data('path'))
      else
        window.dropboxFileLoader.load($this.data('path'), $this.text())

    return $fileList


$ =>
  @dropboxBrowser = new DropboxBrowser()
  @dropboxBrowser.init()

  $('.dropbox-auth').click (e)->
    e.stopPropagation()
