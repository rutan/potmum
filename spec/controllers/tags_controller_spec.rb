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

RSpec.describe TagsController, type: :controller do
  let(:current_user) { create(:user) }
  before { allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user) }

  describe 'PATCH :update' do
    subject do
      patch :update, params: {
        id: @tag.content,
        tag: { name: name, is_menu: '0' }
      }
    end

    before do
      @tag = create(:tag)
    end

    context 'valid name' do
      let(:name) { 'rails' }
      it { is_expected.to redirect_to(tag_path(id: name)) }
      it 'tag name has changed' do
        subject
        expect(Tag.find(@tag.id).name).to eq name
      end
    end

    context 'invalid name' do
      let(:name) { 'ruby on rails' } # include spaces
      it { is_expected.to render_template(:edit) }
      it 'tag name has not changed' do
        subject
        expect(Tag.find(@tag.id).name).not_to eq name
      end
    end
  end
end
