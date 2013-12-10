class MainController < ApplicationController

  require 'dropbox_sdk'

  def index

    job_id = session[:job_id]
    job = Sidekiq::Status::get_all job_id
    @status = job["status"]

  end

  def backup

    instagram_client = Instagram.client(:access_token => session[:instagram_access_token])

    instagram_user = instagram_client.user.username.to_s

    image_urls = []

    page_1 = instagram_client.user_recent_media

    page_1.each do |image|
      image_urls << image["images"]["standard_resolution"]["url"]
    end

    next_page_max_id = page_1.pagination.next_max_id

    until next_page_max_id.nil?

      next_page = instagram_client.user_recent_media(:max_id => next_page_max_id )

      next_page.each do |image|
        image_urls << image["images"]["standard_resolution"]["url"]
      end

      next_page_max_id = next_page.pagination.next_max_id

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
    session.delete(:job_id)

    redirect_to action: 'index'
  end

end
