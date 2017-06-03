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

  describe 'article query' do
    let(:article) { create(:article_with_published_at) }
    let(:access_token) { create(:access_token, :readable) }
    let(:query_string) do
      <<"EOS"
        {
          article(id: "#{article.id}") {
            id
            body
          }
        }
EOS
    end

    it do
      result = subject
      expect(result['data']['article']['id']).to eq article.id
      expect(result['data']['article']['body']).to eq article.newest_revision.body
    end
  end
end
