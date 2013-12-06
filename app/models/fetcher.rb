class Fetcher < ActiveRecord::Base

require 'open-uri'
require 'dropbox_sdk'

  def self.fetch_image(image_url)

    remote_image = open(image_url).read

    file_name = DateTime.now.to_s + ".jpg"

    local_image = "#{Rails.root.to_s}/tmp/images/#{file_name}"

    open(local_image, 'wb').write(remote_image)

  end

end
