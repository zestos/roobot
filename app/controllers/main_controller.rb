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

    job_id = BackupWorker.perform_async(image_urls, dropbox_access_token)

    session[:job_id] = job_id

    redirect_to :action => 'index'

  end

  def status

    job_id = session[:job_id]
    @status = Sidekiq::Status::get_all job_id

    respond_to do |format|
      format.json { render :json => @status }
    end

  end

end
