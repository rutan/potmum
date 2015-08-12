# == Schema Information
#
# Table name: revisions
#
#  id         :integer          not null, primary key
#  article_id :string(128)
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Revision, type: :model do
  describe '#valid?' do
    subject { revision.valid? }
    let(:revision) { create(:revision) }

    context 'valid' do
      before { revision.body = "# h1\nHello, World!" }
      it { is_expected.to be_truthy }
    end

    context 'only space' do
      before { revision.body = ' 　 ' }
      it { is_expected.to be_falsey }
    end

    context '0 characters' do
      before { revision.body = '' }
      it { is_expected.to be_falsey }
    end

    context '100000 characters' do
      before { revision.body = 'a' * 100000 }
      it { is_expected.to be_truthy }
    end

    context '100001 character' do
      before { revision.body = 'a' * 100001 }
      it { is_expected.to be_falsey }
    end
  end
end
