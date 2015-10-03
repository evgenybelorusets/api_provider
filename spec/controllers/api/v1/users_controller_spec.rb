require 'spec_helper'

RSpec.describe Api::V1::UsersController do
  it_behaves_like 'RESTful controller'

  describe '#query_params' do
    let(:client_application) { double :client_application, id: 1 }
    let(:params) { double :params }
    let(:permitted_params) do
      {
        first_name: 'John',
        last_name: 'Snow',
        email: 'knows_nothing@gmail.com',
        role: 'user'
      }
    end

    let(:result) do
      {
        first_name: 'John',
        last_name: 'Snow',
        email: 'knows_nothing@gmail.com',
        role: 1,
        client_application_id: 1
      }
    end

    it 'should permit only :first_name, :last_name, :email, :role, then change role to numeric value and
      merge with client application id' do
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:permit).with(:first_name, :last_name, :email, :role, :uid).and_return permitted_params
      subject.instance_variable_set(:@client_application, client_application)
      expect(subject.send :query_params).to eql result
    end
  end

  describe '#record_params' do
    let(:client_application) { double :client_application, id: 1 }
    let(:params) { double :params }
    let(:required_params) { double :required_params }
    let(:permitted_params) do
      {
        first_name: 'John',
        last_name: 'Snow',
        email: 'knows_nothing@gmail.com',
        role: 'user',
        uid: 'uid',
      }
    end

    let(:result) do
      {
        first_name: 'John',
        last_name: 'Snow',
        email: 'knows_nothing@gmail.com',
        role: 'user',
        uid: 'uid',
        client_application_id: 1
      }
    end

    it 'should require user and permit only :first_name, :last_name, :email, :role and :uid,
      and  then merge client application id' do
      allow(subject).to receive(:params).and_return(params)
      allow(params).to receive(:require).with(:user).and_return required_params
      allow(required_params).to receive(:permit).with(:first_name, :last_name, :email, :uid, :role).
        and_return permitted_params
      subject.instance_variable_set(:@client_application, client_application)
      expect(subject.send :record_params).to eql result
    end
  end
end