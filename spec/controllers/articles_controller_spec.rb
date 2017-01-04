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
#  publish_type       :integer          default(0)
#

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'POST :create' do
    subject { post :create, **params, format: 'json' }

    before(:each) { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }
    let(:current_user) { create(:user) }
    let(:revision_hash) { attributes_for(:revision, user: current_user) }
    let(:params) do
      {
        title:        revision_hash[:title],
        tags_text:    revision_hash[:tags_text],
        body:         revision_hash[:body],
        note:         revision_hash[:note],
        publish_type: 'public_item',
        name:         revision_hash[:user].name
      }
    end

    it { is_expected.to be_success }
    it do
      subject
      article = current_user.articles.last
      revision = article.newest_revision
      aggregate_failures 'testing article' do
        expect(article.title).to        eq params[:title]
        expect(article.publish_type).to eq params[:publish_type]
      end
      aggregate_failures 'testing revision' do
        expect(revision.body).to          eq params[:body]
        expect(revision.title).to         eq params[:title]
        expect(revision.tags_text).to     eq params[:tags_text]
        expect(revision.revision_type).to eq 'published'
        expect(revision.note).to          eq params[:note]
      end
    end
  end
end
