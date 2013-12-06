class BackupToDropbox
@queue = :backup_queue

require 'dropbox_sdk'

  def self.perform(image_urls, dropbox_client)

    image_urls.each do |url|
      remote_image = open(url).read
      dropbox_client.put_file("#{DateTime.now.to_s}.jpg", remote_image)
    end

  end
end