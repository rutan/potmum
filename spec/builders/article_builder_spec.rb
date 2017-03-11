# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ArticleBuilder, type: :model do
  describe '#build' do
    subject { ArticleBuilder.new(article).build(@params) }

    before do
      @user = create(:user)
      @params = {
        title:        'Title string',
        tags_text:    'tag_a tag_b',
        body:         'Body text',
        note:         'Note text',
        publish_type: 'public_item'
      }.merge(user_id: @user.id)
    end

    context 'Create a new article' do
      let(:article) { Article.new }

      it { is_expected.to be_truthy }

      it 'revision has correctly saved' do
        subject
        revision = article.newest_revision

        aggregate_failures 'testing revision' do
          expect(revision.title).to eq 'Title string'
          expect(revision.body).to eq 'Body text'
          expect(revision.note).to eq 'Note text'
          expect(revision.tags_text).to eq 'tag_a tag_b'
          expect(revision.published_at).to be_truthy
          expect(revision.revision_type).to eq 'published'
        end
      end

      it 'article has correctly saved' do
        subject
        aggregate_failures 'testing article' do
          expect(article.user_id).to eq @user.id
          expect(article.title).to eq 'Title string'
          expect(article.published_at).to be_truthy
          expect(article.publish_type).to eq 'public_item'
        end
      end

      it 'tag has correctly saved' do
        subject
        expect(article.tags.map(&:name)).to include('tag_a', 'tag_b')
      end
    end

    context 'Update an existing article' do
      let(:article) { create(:article, user_id: @user.id) }

      it { is_expected.to be_truthy }

      it 'revision has correctly saved' do
        subject
        revision = article.newest_revision
        aggregate_failures 'testing revision' do
          expect(revision.title).to eq 'Title string'
          expect(revision.body).to eq 'Body text'
          expect(revision.note).to eq 'Note text'
          expect(revision.tags_text).to eq 'tag_a tag_b'
          expect(revision.published_at).to be_truthy
          expect(revision.revision_type).to eq 'published'
        end
      end

      it 'article has correctly saved' do
        subject
        aggregate_failures 'testing article' do
          expect(article.title).to eq 'Title string'
          expect(article.published_at).to be_truthy
          expect(article.publish_type).to eq 'public_item'
        end
      end

      it 'tag has correctly saved' do
        subject
        expect(article.tags.map(&:name)).to include('tag_a', 'tag_b')
      end
    end
  end
end
