CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  if GlobalSetting.attachment_file_s3?
    config.storage = :aws
    config.aws_bucket = GlobalSetting.attachment_file_s3_bucket
    config.aws_acl = GlobalSetting.attachment_file_s3_acl
    config.asset_host = GlobalSetting.attachment_file_s3_host
    config.aws_credentials = {
      access_key_id: GlobalSetting.attachment_file_s3_key,
      secret_access_key: GlobalSetting.attachment_file_s3_secret,
      region: GlobalSetting.attachment_file_s3_region,
      endpoint: GlobalSetting.attachment_file_s3_endpoint,
      force_path_style: GlobalSetting.attachment_file_s3_force_path_style
    }.delete_if { |_, v| v.nil? }
  else
    config.storage = :file
    config.asset_host = GlobalSetting.root_url
  end
end
