require 'spec_helper'

RSpec.describe Api::V1::PostsController do
  it_behaves_like 'RESTful controller'

  describe '#query_params' do
    let(:params) { double :params }
    let(:permitted_params) do
      {
        user_id: 1,
        title: 'test'
      }
    end

    it 'should permit only :user_id and :title' do
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:permit).with(:user_id, :title).and_return permitted_params
      expect(subject.send :query_params).to eql permitted_params
    end
  end

  describe '#record_params' do
    let(:params) { double :params }
    let(:user) { double :user, id: 2 }
    let(:required_params) { double :required_params }
    let(:permitted_params) do
      {
        title: 'test title',
        content: 'test content'
      }
    end

    let(:result) do
      {
        title: 'test title',
        content: 'test content',
        user_id: 2
      }
    end

    it 'should require post and permit only :title and content, and then merge user id' do
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:require).with(:post).and_return required_params
      allow(required_params).to receive(:permit).with(:title, :content).
        and_return permitted_params
      allow(subject).to receive(:current_user).and_return user
      expect(subject.send :record_params).to eql result
    end
  end

  describe '#records' do
    let(:record_class) { double :record_class }
    let(:query_params) { double :query_params }
    let(:records) { double :records }
    let(:records_with_included_user) { double :records_wih_included_user }

    before :each do
      allow(subject).to receive(:record_class).and_return record_class
      allow(subject).to receive(:query_params).and_return query_params
    end

    it 'should return records for query params' do
      allow(record_class).to receive(:where).with(query_params).once.and_return records
      allow(records).to receive(:includes).with(:user).and_return records_with_included_user
      expect(subject.send :records).to eql records_with_included_user
      expect(subject.send :records).to eql records_with_included_user
    end
  end
end