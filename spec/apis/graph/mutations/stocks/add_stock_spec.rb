# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'AddStock Mutation' do
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
          addStock(input: {subjectId: "#{id}"}) {
            article {
              id
              title
              isStocked
            }
          }
        }
EOS
  end
  let(:variables) { {} }
  let(:access_token) { create(:access_token, :writable) }

  context 'public_item' do
    let(:article) { create(:article, :public_item) }
    let(:id) { "Article::#{article.id}" }

    it do
      result = subject
      expect(result['data']['addStock']['article']['id']).to eq "Article::#{article.id}"
      expect(result['data']['addStock']['article']['isStocked']).to eq true
    end
  end

  context 'private_item' do
    let(:article) { create(:article, :private_item) }
    let(:id) { "Article::#{article.id}" }

    it do
      result = subject
      expect(result['data']['addStock']['article']['id']).to eq "Article::#{article.id}"
      expect(result['data']['addStock']['article']['isStocked']).to eq true
    end
  end

  context 'draft_item' do
    let(:article) { create(:article, :draft) }
    let(:id) { "Article::#{article.id}" }

    it do
      result = subject
      expect(result['data']['addStock']).to eq nil
      expect(result['errors']).to be_truthy
    end
  end

  context 'stocked item' do
    let(:article) { create(:article, :public_item) }
    let(:id) { "Article::#{article.id}" }

    before do
      create(:stock, article_id: article.id, user_id: access_token.user.id)
    end

    it do
      result = subject
      expect(result['data']['addStock']).to eq nil
      expect(result['errors']).to be_truthy
    end
  end
end
