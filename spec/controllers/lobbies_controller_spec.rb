# frozen_string_literal: true
require 'rails_helper'

RSpec.describe LobbiesController, type: :controller do
  describe 'GET :root' do
    subject { get :root, params: params; response }
    let(:params) { {} }

    it { expect(subject.status).to eq 200 }

    context 'settable page' do
      let(:params) { {page: 2} }
      it do
        subject
        expect(assigns(:page)).to eq 2
      end
    end
  end

  describe 'GET :newest' do
    subject { get :newest; response }
    it { expect(subject.status).to eq 200 }
  end

  describe 'GET :popular' do
    subject { get :popular; response }
    it { expect(subject.status).to eq 200 }
  end

  describe 'GET :comments' do
    subject { get :comments; response }
    it { expect(subject.status).to eq 200 }
  end

  describe 'GET :search' do
    subject { get :search, params: {q: query}; response }
    let(:query) { 'search-word' }

    it { expect(subject.status).to eq 200 }
    it do
      subject
      expect(assigns(:search_result).query).to eq 'search-word'
    end
  end

  describe 'GET :redirector' do
    subject { get :redirector, params: {url: url}; response }

    context 'valid url' do
      let(:url) { 'http://example.com/valid/path' }
      it { expect(subject.status).to eq 200 }
    end

    context 'invalid url' do
      let(:url) { 'this is not url' }
      it { expect(subject.status).to eq 400 }
    end
  end
end
