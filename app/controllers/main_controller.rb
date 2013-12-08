class MainController < ApplicationController

  require 'dropbox_sdk'

  def index

  end

  def backup

    instagram_client = Instagram.client(:access_token => session[:instagram_access_token])

    instagram_user = instagram_client.user.username.to_s

    recent_media_items = instagram_client.user_recent_media(:count => -1)

    image_urls = []

    recent_media_items.each do |image|
      image_urls << image["images"]["standard_resolution"]["url"]
    end

    dropbox_access_token = session[:access_token]

    job_id = BackupWorker.perform_async(image_urls, instagram_user, dropbox_access_token)

    session[:job_id] = job_id

    render nothing: true

  end

  def status

    job_id = session[:job_id]
    @status = Sidekiq::Status::get_all job_id

    respond_to do |format|
      format.json { render :json => @status }
    end

  end

  def logout
    session.delete(:instagram_access_token)
    session.delete(:access_token)

    redirect_to action: 'index'
  end

end
