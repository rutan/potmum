# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  name          :string(64)       not null
#  content       :string(64)       not null
#  article_count :integer          default(0), not null
#  is_menu       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  key           :string(128)
#

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe '#valid?' do
    subject { tag.valid? }
    let(:tag) { create(:tag) }

    describe '#content' do
      context 'Word' do
        before { tag.content = 'Word' }
        it { is_expected.to be_truthy }
      end

      context '40 characters' do
        before { tag.content = 'a' * 40 }
        it { is_expected.to be_truthy }
      end

      context '41 characters' do
        before { tag.content = 'a' * 41 }
        it { is_expected.to be_falsey }
      end

      context '0 character' do
        before { tag.content = '' }
        it { is_expected.to be_falsey }
      end

      context 'include space' do
        before { tag.content = 'Ruby Python' }
        it { is_expected.to be_falsey }
      end

      context 'include return' do
        before { tag.content = "Ru\nShalm" }
        it { is_expected.to be_falsey }
      end
    end
  end

  describe '#name=' do
    describe '#content' do
      subject { tag.name = name; tag.content }
      let(:tag) { build(:tag) }

      context 'Ruby' do
        let(:name) { 'Ruby' }
        it { is_expected.to eq 'ruby' }
      end

      context 'ruby' do
        let(:name) { 'ruby' }
        it { is_expected.to eq 'ruby' }
      end
    end
  end
end
