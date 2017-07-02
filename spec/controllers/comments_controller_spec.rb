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
#  key        :string(128)
#

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before :each do
    allow_any_instance_of(Notifiers::Slack).to receive(:post).and_return(true)
  end

  describe 'POST :create' do
    subject do
      post :create, params: {
        name: article.user.name,
        article_id: article.id,
        body: body
      }, format: 'json'
      response
    end

    let(:article) { create(:article_with_published_at) }

    context 'not login' do
      let(:body) { 'not login' }
      it { expect(subject.status).to eq 401 }
    end

    context 'login' do
      before(:each) { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }
      let(:current_user) { create(:user) }

      context 'valid comment' do
        let(:body) { 'test' }
        it { expect(subject.status).to eq 201 }
        it { expect { subject }.to change { article.comments.reload.count }.by(1) }
        it { expect { subject }.to change { article.reload.comment_count }.by(1) }
      end

      context 'invalid comment' do
        let(:body) { ' ' }
        it { expect(subject.status).to eq 400 }
        it { expect { subject }.not_to change(Comment, :count) }
      end
    end
  end

  describe 'DELETE :destroy' do
    subject { delete :destroy, params: {id: comment.id}, format: 'json'; response }
    let(:article) { create(:article_with_published_at) }
    let :comment do
      build(:comment).tap do |c|
        c.article = article
        c.save
        article.update_comment_count
      end
    end
    before(:each) { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

    context 'login with comment-author' do
      let(:current_user) { comment.user }

      it { expect(subject.status).to eq 200 }
      it { expect { subject }.to change { article.comments.reload.count }.by(-1) }
      it { expect { subject }.to change { article.reload.comment_count }.by(-1) }
    end

    context 'login with not comment-author' do
      let(:current_user) { create(:user) }

      it { expect(subject.status).to eq 403 }
      it { expect { subject }.to change { article.comments.reload.count } }
    end
  end
end
