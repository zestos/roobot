class MainController < ApplicationController

  require 'dropbox_sdk'

  def index

  end

  def backup

    instagram_client = Instagram.client(:access_token => session[:instagram_access_token])

    # recent_media_items = instagram_client.user_recent_media
    all_media_items = []

    page_1 = instagram_client.user_recent_media
    all_media_items << page_1
    max_id = page_1.pagination.next_max_id

    while max_id != nil
      next_page = instagram_client.user_recent_media(:max_id => max_id )
      all_media_items << next_page
      max_id = next_page.pagination.next_max_id
      sleep 0.2
    end

    image_urls = []

    all_media_items[0].each do |image|
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
