require 'spec_helper'

RSpec.describe Api::V1::CommentsController do
  context 'controller behaviour' do
    it_behaves_like 'RESTful controller', post_id: 1
  end

  describe '#query_params' do
    let(:params) { double :params }
    let(:pst) { double :pst, id: 2 }
    let(:permitted_params) do
      {
        user_id: 1,
        post_id: 2
      }
    end

    it 'should permit only :user_id and merge post id' do
      allow(subject).to receive(:post).and_return pst
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:permit).with(:user_id).and_return permitted_params
      expect(subject.send :query_params).to eql permitted_params
    end
  end

  describe '#record_params' do
    let(:params) { double :params }
    let(:user) { double :user, id: 2 }
    let(:pst) { double :pst, id: 3 }
    let(:required_params) { double :required_params }
    let(:permitted_params) do
      {
        content: 'test content'
      }
    end

    let(:result) do
      {
        content: 'test content',
        user_id: 2,
        post_id: 3
      }
    end

    it 'should require comment and permit only :content, and then merge user and post id' do
      allow(subject).to receive(:post).and_return pst
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:require).with(:comment).and_return required_params
      allow(required_params).to receive(:permit).with(:content).
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