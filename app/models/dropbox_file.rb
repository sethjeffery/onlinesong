class DropboxFile < OpenStruct
  def self.download(client, path)
    new(client.media(path).with_indifferent_access)
  end

  def basename
    File.basename(self.path) if self.path
  end

  def human_name
    basename.gsub(/\.\w+$/, '').humanize if basename
  end

  def as_json
    {
        type: 'file',
        basename: basename,
        human_name: human_name,
        mime_type: mime_type,
        path: path || url,
        expires: expires,
    }
  end
end
