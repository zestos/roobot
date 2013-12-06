class MainController < ApplicationController

  require 'dropbox_sdk'

  def index

  end

  def backup

    instagram_client = Instagram.client(:access_token => session[:instagram_access_token])

    recent_media_items = instagram_client.user_recent_media

    image_urls = []

    recent_media_items.each do |image|
      image_urls << image["images"]["standard_resolution"]["url"]
    end

    dropbox_access_token = session[:access_token]

    BackupWorker.perform_async(image_urls, dropbox_access_token)

    redirect_to :action => 'index'

  end

end
