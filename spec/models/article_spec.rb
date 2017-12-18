# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id                 :string(128)      not null, primary key
#  user_id            :integer
#  title              :string(128)
#  newest_revision_id :integer
#  view_count         :integer          default(0), not null
#  stock_count        :integer          default(0), not null
#  comment_count      :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published_at       :datetime
#  publish_type       :integer          default("draft_item")
#  like_count         :integer          default(0)
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#valid?' do
    subject { article.valid? }
    let(:article) { create(:article) }

    describe '#title' do
      context 'valid' do
        before { article.title = 'Title String' }
        it { is_expected.to be_truthy }
      end

      context 'only space' do
        before { article.title = ' 　 ' }
        it { is_expected.to be_falsey }
      end

      context '0 characters' do
        before { article.title = '' }
        it { is_expected.to be_falsey }
      end

      context '64 characters' do
        before { article.title = 'a' * 64 }
        it { is_expected.to be_truthy }
      end

      context '65 character' do
        before { article.title = 'a' * 65 }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '.hot_entries' do
    context 'empty' do
      subject { Article.hot_entries }
      it { is_expected.to be_empty }
    end

    context 'has items' do
      subject { Article.hot_entries.first }

      before do
        @article1 = create(:article, :public_item)
        @article1.hit(:views)
        @article2 = create(:article, :public_item)
        @article2.hit(:views)
        @article2.hit(:likes)
      end

      it { is_expected.to eq @article2 }
    end
  end
end
