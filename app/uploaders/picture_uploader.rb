# frozen_string_literal: true
class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    model.class.to_s.pluralize.underscore.to_s
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, "#{Time.now.to_i}-#{SecureRandom.hex(32)}")
  end
end
