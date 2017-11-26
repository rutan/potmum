# frozen_string_literal: true

# == Schema Information
#
# Table name: access_tokens
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  token_type  :integer          default("system_token")
#  permit_type :integer          default("permit_read_only")
#  title       :string(32)
#  token       :string(128)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#valid?' do
    subject { access_token.valid? }
    let(:access_token) { create(:access_token) }

    describe '#title' do
      context 'valid' do
        before { access_token.title = 'API Token Title' }
        it { is_expected.to be_truthy }
      end

      context '0 characters' do
        before { access_token.title = '' }
        it { is_expected.to be_falsey }
      end

      context '32 characters' do
        before { access_token.title = 'a' * 32 }
        it { is_expected.to be_truthy }
      end

      context '33 character' do
        before { access_token.title = 'a' * 33 }
        it { is_expected.to be_falsey }
      end
    end
  end
end
