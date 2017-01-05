# frozen_string_literal: true
# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  article_id :string(128)      not null
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#valid?' do
    subject { comment.valid? }
    let(:comment) { create(:comment_with_article) }

    describe '#body' do
      context 'valid' do
        before { comment.body = 'Thx!' }
        it { is_expected.to be_truthy }
      end

      context 'only space' do
        before { comment.body = ' 　 ' }
        it { is_expected.to be_falsey }
      end

      context '0 characters' do
        before { comment.body = '' }
        it { is_expected.to be_falsey }
      end

      context '2048 characters' do
        before { comment.body = 'a' * 2048 }
        it { is_expected.to be_truthy }
      end

      context '2049 character' do
        before { comment.body = 'a' * 2049 }
        it { is_expected.to be_falsey }
      end
    end
  end
end
