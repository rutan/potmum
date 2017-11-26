# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'RemoveStock Mutation' do
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
    <<"QUERY"
        mutation {
          removeStock(input: {subjectId: "#{id}"}) {
            article {
              id
              title
              isStocked
            }
          }
        }
QUERY
  end
  let(:variables) { {} }
  let(:access_token) { create(:access_token, :writable) }

  context 'public item' do
    let(:article) { create(:article, :public_item) }
    let(:id) { "Article::#{article.id}" }

    context 'stocked item' do
      before do
        create(:stock, article_id: article.id, user_id: access_token.user.id)
      end

      it do
        result = subject
        expect(result['data']['removeStock']['article']['id']).to eq "Article::#{article.id}"
        expect(result['data']['removeStock']['article']['isStocked']).to eq false
      end
    end

    context 'no stocked item' do
      it do
        result = subject
        expect(result['data']['removeStock']).to eq nil
        expect(result['errors']).to be_truthy
      end
    end
  end
end
