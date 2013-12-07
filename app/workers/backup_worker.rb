class BackupWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  require 'dropbox_sdk'

  def perform(image_urls, dropbox_access_token)

    dropbox_client = DropboxClient.new(dropbox_access_token)

    # Dir.mkdir(File.join(Rails.root, 'tmp'))

    image_urls.each do |url|
      remote_image = open(url).read

      binding.pry

      dropbox_client.put_file("#{DateTime.now.to_s}.jpg", remote_image)
    end

  end

end