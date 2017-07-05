# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'RemoveComment Mutation' do
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
          removeComment(input: {clientMutationId: "rspec", commentId: "#{id}"}) {
            clientMutationId
          }
        }
EOS
  end
  let(:variables) { {} }
  let(:id) { "Comment::#{comment.key}" }
  let(:body) { 'test message' }

  context 'my comment' do
    let(:comment) { create(:comment) }
    let(:access_token) { create(:access_token, :writable, user_id: comment.user.id) }

    it do
      result = subject
      expect(result['data']['removeComment']['clientMutationId']).to eq 'rspec'
      expect(result['errors']).to eq nil
    end
  end

  context 'other user\'s comment' do
    let(:comment) { create(:comment) }
    let(:access_token) { create(:access_token, :writable) }

    it do
      result = subject
      expect(result['data']['removeComment']).to eq nil
      expect(result['errors']).to be_truthy
    end
  end
end
