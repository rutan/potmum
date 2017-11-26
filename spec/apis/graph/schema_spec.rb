# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Graph::Schema do
  subject do
    Graph::Schema.execute(
      query_string,
      variables: variables,
      context: {
        access_token: access_token
      }
    )
  end
  let(:variables) { {} }

  describe 'node query' do
    let(:access_token) { create(:access_token, :readable) }
    let(:query_string) do
      <<"QUERY"
        {
          node(id: "#{id}") {
            id
          }
        }
QUERY
    end

    context 'Article' do
      let(:id) { "Article::#{article.id}" }

      let(:article) { create(:article_with_published_at) }
      it do
        result = subject
        expect(result['data']['node']['id']).to eq "Article::#{article.id}"
      end
    end

    context 'User' do
      let(:user) { create(:user) }
      let(:id) { "User::#{user.id}" }
      it do
        result = subject
        expect(result['data']['node']['id']).to eq "User::#{user.id}"
      end
    end

    context 'Comment' do
      let(:comment) { create(:comment) }
      let(:id) { "Comment::#{comment.key}" }
      it do
        result = subject
        expect(result['data']['node']['id']).to eq "Comment::#{comment.key}"
      end
    end
  end

  describe 'article query' do
    let(:article) { create(:article_with_published_at) }
    let(:access_token) { create(:access_token, :readable) }
    let(:query_string) do
      <<"QUERY"
        {
          article(id: "Article::#{article.id}") {
            id
            objectId
            body
          }
        }
QUERY
    end

    it do
      result = subject
      expect(result['data']['article']['id']).to eq "Article::#{article.id}"
      expect(result['data']['article']['objectId']).to eq article.id
      expect(result['data']['article']['body']).to eq article.newest_revision.body
    end
  end
end
