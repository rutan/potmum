# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'AddComment Mutation' do
  subject do
    Graph::Schema.execute(
      query_string,
      variables: variables,
      context: {
        access_token: access_token
      }
    )
  end
  let(:query_string) do
    <<"EOS"
        mutation {
          addComment(input: {subjectId: "#{id}", body: "#{body}"}) {
            comment {
              id
              body
              article {
                id
              }
            }
          }
        }
EOS
  end
  let(:variables) { {} }
  let(:access_token) { create(:access_token, :writable) }
  let(:id) { "Article::#{article.id}" }
  let(:body) { 'test message' }

  context 'public_item' do
    let(:article) { create(:article, :public_item) }

    it do
      result = subject
      expect(result['data']['addComment']['comment']['body']).to eq body
      expect(result['data']['addComment']['comment']['article']['id']).to eq "Article::#{article.id}"
    end
  end

  context 'private_item' do
    let(:article) { create(:article, :private_item) }

    it do
      result = subject
      expect(result['data']['addComment']['comment']['body']).to eq body
      expect(result['data']['addComment']['comment']['article']['id']).to eq "Article::#{article.id}"
    end
  end

  context 'draft_item' do
    let(:article) { create(:article, :draft) }

    it do
      result = subject
      expect(result['data']['addComment']).to eq nil
      expect(result['errors']).to be_truthy
    end
  end
end
