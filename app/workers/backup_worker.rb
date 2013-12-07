class BackupWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  require 'dropbox_sdk'

  def perform(image_urls, instagram_user, dropbox_access_token)

    dropbox_client = DropboxClient.new(dropbox_access_token)

    ig_un = instagram_user

    i = 1

    image_urls.each do |url|
      remote_image = Net::HTTP.get(URI.parse(url))
      dropbox_client.put_file("#{ig_un}_igphoto_#{i}.jpg", remote_image)
      i += 1
    end

  end

end