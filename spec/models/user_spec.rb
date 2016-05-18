# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(32)       not null
#  email       :string
#  stock_count :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  role        :integer          default(0)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
    subject { user.valid? }
    let(:user) { create(:user) }

    describe '#name' do
      context 'valid' do
        before { user.name = 'ru_shalm' }
        it { is_expected.to be_truthy }
      end

      context 'invalid character' do
        before { user.name = 'ru_shalm?' }
        it { is_expected.to be_falsey }
      end

      context 'not ascii' do
        before { user.name = 'るたん' }
        it { is_expected.to be_falsey }
      end

      context '2 characters' do
        before { user.name = 'a' * 2 }
        it { is_expected.to be_falsey }
      end

      context '3 characters' do
        before { user.name = 'a' * 3 }
        it { is_expected.to be_truthy }
      end

      context '16 characters' do
        before { user.name = 'a' * 16 }
        it { is_expected.to be_truthy }
      end

      context '17 characters' do
        before { user.name = 'a' * 17 }
        it { is_expected.to be_falsey }
      end

      context 'not unique' do
        before do
          other_user = create(:user)
          user.name = other_user.name
        end
        it { is_expected.to be_falsey }
      end
    end

    describe '#email' do
      context 'valid' do
        before { user.email = 'email@example.com' }
        it { is_expected.to be_truthy }
      end

      context 'not mail address' do
        before { user.email = 'http://example.com' }
        it { is_expected.to be_falsey }
      end
    end
  end
end
