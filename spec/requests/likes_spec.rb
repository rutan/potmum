# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'likes', type: :request do
  let(:current_user) { create(:user) }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

  describe 'POST /@:name/items/:article_id/like.json' do
    subject do
      post "/@#{article.user.name}/items/#{article.id}/like.json"
    end

    let(:article) { create(:article_with_published_at) }

    it { is_expected.to eq 200 }
    it { expect { subject }.to change { article.likes.reload.count }.by(1) }
    it { expect { subject }.to change { article.reload.like_count }.by(1) }
  end

  describe 'DELETE /@:name/items/:article_id/like' do
    subject do
      delete "/@#{article.user.name}/items/#{article.id}/like.json"
    end

    let(:article) { create(:article_with_published_at) }

    before do
      create(:like, target: article, user: current_user).tap do |c|
        c.target.update_like_count
      end
    end

    it { is_expected.to eq 204 }
    it { expect { subject }.to change { article.likes.reload.count }.by(-1) }
    it { expect { subject }.to change { article.reload.like_count }.by(-1) }
  end
end
