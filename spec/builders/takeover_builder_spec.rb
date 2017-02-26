# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TakeoverBuilder, type: :model do
  describe '#build' do
    subject { TakeoverBuilder.new(@to_user).build(@from_user) }
    before do
      @from_user = create(:user)
      @to_user   = create(:user)
    end

    describe 'migrate articles' do
      before do
        @other_user = create(:user)
        @article1   = create(:article, user: @from_user)
        @article2   = create(:article, user: @other_user)
      end

      it "to_user has from_user's articles" do
        subject
        expect(@to_user.article_ids).to eq [@article1.id]
      end

      it "other_user's articles have not been migrated" do
        subject
        expect(@other_user.articles).to eq [@article2]
      end
    end

    describe "delete from_user's stocks" do
      before do
        other_user = create(:user)
        article    = create(:article, user: other_user)
        @stock     = create(:stock, user: @from_user, article: article)
      end

      it "from_user's stocks are destroyed" do
        subject
        expect { @stock.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
