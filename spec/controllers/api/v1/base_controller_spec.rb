require 'spec_helper'

RSpec.describe Api::V1::BaseController do
  context 'filters' do
    it { expect(subject).to use_before_filter :authenticate }
  end

  describe '#record_class' do
    let(:fake_base_model) { double :fake_base_model }

    before :each do
      stub_const('Base', fake_base_model)
    end

    it 'should return record class' do
      expect(subject.send :record_class).to eql fake_base_model
    end
  end

  describe '#record' do
    let(:record_class) { double :record_class }
    let(:record_params) { double :record_params }
    let(:record) { double :record }

    before :each do
      allow(subject).to receive(:record_class).and_return record_class
      allow(subject).to receive(:record_params).and_return record_params
    end

    it 'should search for record if :id is present in params' do
      allow(subject).to receive(:params).and_return(id: 1)
      allow(record_class).to receive(:find).with(1).once.and_return record
      expect(subject.send :record).to eql record
      expect(subject.send :record).to eql record
    end

    it 'should initialize new record with record params if there is no :id in params' do
      allow(subject).to receive(:params).and_return({})
      allow(record_class).to receive(:new).with(record_params).once.and_return record
      expect(subject.send :record).to eql record
      expect(subject.send :record).to eql record
    end
  end

  describe '#records' do
    let(:record_class) { double :record_class }
    let(:query_params) { double :query_params }
    let(:records) { double :records }

    before :each do
      allow(subject).to receive(:record_class).and_return record_class
      allow(subject).to receive(:query_params).and_return query_params
    end

    it 'should return records for query params' do
      allow(record_class).to receive(:where).with(query_params).once.and_return records
      expect(subject.send :records).to eql records
      expect(subject.send :records).to eql records
    end
  end

  describe '#current_user' do
    let(:user) { double :user }
    let(:guest) { double :guest }

    it 'should search for user by uid and return him if present' do
      allow(subject).to receive(:params).and_return(user_uid: 'uid')
      allow(User).to receive(:find_by).with(uid: 'uid').once.and_return user
      expect(subject.send :current_user).to eql user
      expect(subject.send :current_user).to eql user
    end

    it 'should return quest if there is no user for passed uid' do
      allow(subject).to receive(:params).and_return(user_uid: 'uid')
      allow(User).to receive(:find_by).with(uid: 'uid').once
      allow(User).to receive(:guest).once.and_return guest
      expect(subject.send :current_user).to eql guest
      expect(subject.send :current_user).to eql guest
    end
  end

  describe '#authenticate' do
    let(:client_application) { double :client_application }

    before :each do
      allow(subject).to receive(:authenticate_with_http_basic).and_yield('key', 'secret')
    end

    it 'should load client application with given credentials' do
      allow(ClientApplication).to receive(:find_by).with(key: 'key', secret: 'secret').
        and_return client_application
      subject.send :authenticate
      expect(assigns[:client_application]).to eql client_application
    end

    it 'should render response with 401 HTTP status if there is no client application for given credentials' do
      allow(ClientApplication).to receive(:find_by).with(key: 'key', secret: 'secret')
      expect(subject).to receive(:head).with(:unauthorized)
      subject.send :authenticate
    end
  end
end