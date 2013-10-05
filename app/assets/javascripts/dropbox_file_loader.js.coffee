class DropboxFileLoader
  path: null

  load: (path, title) ->
    $.get '/dropbox/download' + path, (data) =>
      $.get data.path, (data) =>
        @path = path
        window.editor.$editor.html(data)
        window.previewer.update()

$ =>
  @dropboxFileLoader = new DropboxFileLoader()
