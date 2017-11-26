# frozen_string_literal: true

# == Schema Information
#
# Table name: attachment_files
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  file       :string(128)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AttachmentFile < ApplicationRecord
  belongs_to :user
  mount_uploader :file, PictureUploader

  validates :user,
            presence: true

  validates :file,
            presence: true
end
