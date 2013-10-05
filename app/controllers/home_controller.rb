require 'dropbox_sdk'

class HomeController < ApplicationController

  def index
    config = Rails.application.config

    if session[:dropbox_access_token].nil?
      flow = DropboxOAuth2FlowNoRedirect.new(config.dropbox_key, config.dropbox_secret)
      @dropbox_auth_url = flow.start()
      session[:flow] = flow
    end
  end


  def auth
    flow = session[:flow]
    access_token, user_id = flow.finish(params[:code])
    session[:dropbox_access_token] = access_token
    redirect_to root_path
  end

  def download
    contents = params[:contents] || ""
    lines = contents.gsub(/\r\n?/, "\n").split("\n")
    filename = lines.select{|l| l.length > 1}[0].try(:[], 0..30).try(:titleize)

    send_data contents, filename: "#{filename || "song"}.onsong"
  end
end
