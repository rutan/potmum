require 'rails_helper'

RSpec.describe Article, type: :model do
  describe '#valid?' do
    subject { article.valid? }
    let(:article) { create(:article) }

    describe '#title' do
      context 'valid' do
        before { article.title = 'Title String' }
        it { is_expected.to be_truthy }
      end

      context 'only space' do
        before { article.title = ' 　 ' }
        it { is_expected.to be_falsey }
      end

      context '0 characters' do
        before { article.title = '' }
        it { is_expected.to be_falsey }
      end

      context '64 characters' do
        before { article.title = 'a' * 64 }
        it { is_expected.to be_truthy }
      end

      context '65 character' do
        before { article.title = 'a' * 65 }
        it { is_expected.to be_falsey }
      end
    end
  end
end
