# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SearchArticleService, type: :model do
  describe '#call' do
    subject do
      SearchArticleService.new.call(
        access_token: access_token,
        query: query,
        page: 1,
        size: 10
      )
    end

    let(:access_token) { nil }

    context 'search public article' do
      before do
        article1 = create(:article_with_published_at)
        article1.newest_revision.update(body: 'apple')
        article2 = create(:article_with_published_at)
        article2.newest_revision.update(body: 'google')
      end

      let(:query) { 'apple' }

      it do
        result = subject
        expect(result.total_count).to eq 1
        expect(result.articles.first.decorate.body).to eq 'apple'
      end
    end

    context 'private article' do
      before { article }
      let(:query) { 'apple' }

      let(:article) do
        article = create(:article_with_published_at, publish_type: 'private_item')
        article.newest_revision.update(body: 'apple')
        article
      end

      context 'visiable author' do
        let(:access_token) { AccessToken.generate_master(article.user) }

        it do
          result = subject
          expect(result.total_count).to eq 1
        end
      end

      context 'hidden other user' do
        let(:access_token) { create(:user) }

        it do
          result = subject
          expect(result.total_count).to eq 0
        end
      end
    end
  end
end
