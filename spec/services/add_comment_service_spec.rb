# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddCommentService, type: :model do
  describe '#call' do
    subject do
      AddCommentService.new.call(
        access_token: access_token,
        article_id: article_id,
        body: 'comment body'
      )
    end

    context 'with writable token' do
      let(:access_token) { build(:access_token, :writable) }

      context 'to published article' do
        let(:article) { create(:article_with_published_at) }
        let(:article_id) { article.id }

        it 'success add comment' do
          expect { subject }.to change { Comment.count }.by(1)
        end

        it 'success update article#comment_count' do
          expect { subject }.to change { article.reload.comment_count }.by(1)
        end

        it 'comment has correctly saved' do
          subject
          aggregate_failures 'testing comment' do
            comment = article.comments.last
            expect(comment.user_id).to eq access_token.user.id
            expect(comment.body).to eq 'comment body'
          end
        end

        context 'to public item' do
          let(:article) { create(:article_with_published_at, :public_item) }

          it 'call notify slack' do
            expect(GlobalSetting).to receive(:notify_slack?).once
            subject
          end
        end

        context 'to private item' do
          let(:article) { create(:article_with_published_at, :private_item) }

          it 'not call notify slack' do
            expect(GlobalSetting).not_to receive(:notify_slack?)
            subject
          end
        end
      end

      context 'to draft article' do
        let(:article) { create(:article) }
        let(:article_id) { article.id }

        it 'missing add comment' do
          expect { subject }.to raise_error(Pundit::NotAuthorizedError)
        end
      end
    end

    context 'with readable token' do
      let(:access_token) { build(:access_token, :readable) }
      let(:article_id) { create(:article_with_published_at).id }

      it 'missing add comment' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'with no token' do
      let(:access_token) { nil }
      let(:article_id) { create(:article_with_published_at).id }

      it 'missing add comment' do
        expect { subject }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
