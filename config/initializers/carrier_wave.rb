if Rails.env.production?
  CarrierWave.configure do |connfig|
    config.fog_credentials = {
      :provider => 'AWS',
      :region => EMV['S3_REGION'],
      :aws_access_key_id => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory = ENV['S3_BUCKET']
  end
end
