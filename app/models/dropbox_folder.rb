class DropboxFolder < OpenStruct
  def self.load(client, path)
    new(client.metadata(path).with_indifferent_access)
  end

  def files
    @files ||= self.contents.present? ? self.contents.map{|item| item["is_dir"] ? DropboxFolder.new(item.with_indifferent_access) : DropboxFile.new(item.with_indifferent_access) } : []
  end

  def parent_path
    self.path.match(/^(.+)\/[^\/]+$/).try(:[], 1) || '/'
  end

  def basename
    File.basename(self.path)
  end

  def human_name
    basename.gsub(/\.\w+$/, '').humanize
  end

  def as_json(options={})
    {
        type: 'folder',
        basename: basename,
        human_name: human_name,
        path: path,
        parent_path: parent_path,
        files: files.as_json,
    }
  end

end
