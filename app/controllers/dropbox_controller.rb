require 'dropbox_sdk'

class DropboxController < ApplicationController

  def browse
    begin
      @folder = DropboxFolder.load(client, path)
      render json: @folder.as_json
    rescue ArgumentError
      render json: { failed: true }
    end
  end

  def download
    @file = DropboxFile.download(client, path)
    render json: @file.as_json
  end

  private

  def dropbox_session
    session[:dropbox_access_token] || params[:dropbox_access_token]
  end

  def client
    @client ||= DropboxClient.new(dropbox_session)
  end

  def path
    "#{params[:path] || '/'}#{'.' + params[:format] if params[:format].present?}"
  end
end
