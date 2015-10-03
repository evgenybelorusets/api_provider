require 'spec_helper'

RSpec.describe Api::V1::BaseController do
  context 'filters' do
    it { should use_before_filter :authenticate }
  end

  context 'actions' do
    let(:record) { double :record, errors: { some: :errors } }
    let(:records) { double :records }
    let(:record_class) { double :record_class }

    before :each do
      allow(subject).to receive(:render)
      allow(subject).to receive(:respond_with)
      allow(subject).to receive(:record).and_return record
      allow(subject).to receive(:records).and_return records
      allow(subject).to receive(:record_class).and_return record_class
      allow(record).to receive(:save)
      allow(record).to receive(:update_attributes)
    end

    describe '#create' do
      before :each do
        allow(subject).to receive(:authorize!).with(:create, record_class)
      end

      it 'should authorise resource access' do
        expect(subject).to receive(:authorize!).with(:create, record_class)
        subject.create
      end

      it 'should render :show with 201 HTTP status if record was successfully created' do
        expect(record).to receive(:save).and_return true
        expect(subject).to receive(:render).with(:show, status: :created)
        subject.create
      end

      it 'should render errors with 422 HTTP status if record was not created' do
        expect(record).to receive(:save).and_return false
        expect(subject).to receive(:render).with(json: { errors: { some: :errors } }, status: :unprocessable_entity)
        subject.create
      end
    end

    describe '#index' do
      before :each do
        allow(subject).to receive(:authorize!).with(:read, record_class)
      end

      it 'should authorise resource access' do
        expect(subject).to receive(:authorize!).with(:read, record_class)
        subject.index
      end

      it 'should respond with records' do
        expect(subject).to receive(:respond_with).with(records)
        subject.index
      end
    end

    describe '#update' do
      let(:record_params) { double :record_params }

      before :each do
        allow(subject).to receive(:authorize!).with(:update, record)
        allow(subject).to receive(:record_params).and_return record_params
      end

      it 'should authorise resource access' do
        expect(subject).to receive(:authorize!).with(:update, record)
        subject.update
      end

      it 'should render :show if record was successfully updated' do
        expect(record).to receive(:update_attributes).with(record_params).and_return true
        expect(subject).to receive(:render).with(:show)
        subject.update
      end

      it 'should render errors with 422 HTTP status if record was not created' do
        expect(record).to receive(:update_attributes).with(record_params).and_return false
        expect(subject).to receive(:render).with(json: { errors: { some: :errors } }, status: :unprocessable_entity)
        subject.update
      end
    end

    describe '#show' do
      before :each do
        allow(subject).to receive(:authorize!).with(:read, record)
      end

      it 'should authorise resource access' do
        expect(subject).to receive(:authorize!).with(:read, record)
        subject.show
      end

      it 'should response with record' do
        expect(subject).to receive(:respond_with).with(record)
        subject.show
      end
    end

    describe '#destroy' do
      before :each do
        allow(subject).to receive(:authorize!).with(:destroy, record)
        allow(record).to receive(:destroy)
        allow(subject).to receive(:head)
      end

      it 'should authorise resource access' do
        expect(subject).to receive(:authorize!).with(:destroy, record)
        subject.destroy
      end

      it 'should destroy record and render response with 204 HTTP status' do
        expect(record).to receive(:destroy)
        expect(subject).to receive(:head).with(:no_content)
        subject.destroy
      end
    end
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
      allow(User).to receive(:find_by_uid).with('uid').once.and_return user
      expect(subject.send :current_user).to eql user
      expect(subject.send :current_user).to eql user
    end

    it 'should return quest if there is no user for passed uid' do
      allow(subject).to receive(:params).and_return(user_uid: 'uid')
      allow(User).to receive(:find_by_uid).with('uid').once
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
      allow(ClientApplication).to receive(:find_by_key_and_secret).with('key', 'secret').
        and_return client_application
      subject.send :authenticate
      expect(assigns[:client_application]).to eql client_application
    end

    it 'should render response with 401 HTTP status if there is no client application for given credentials' do
      allow(ClientApplication).to receive(:find_by_key_and_secret).with('key', 'secret')
      expect(subject).to receive(:head).with(:unauthorized)
      subject.send :authenticate
    end
  end
end