RSpec.shared_examples 'RESTful controller' do |params = {}|
  let(:record_class) { double :record_class }
  let(:record) { double :record }
  let(:records) { double :records }

  context 'rescue from' do
    it 'should render response with 403 HTTP status if action raised CanCan::AccessDenied' do
      allow(controller).to receive(:authorize!) { raise CanCan::AccessDenied }
      get :index, params.merge(user_uid: 'test')
      expect(response.status).to eql 403
    end

    it 'should render response with 403 HTTP status if action raised ActiveRecord::RecordNotFound' do
      allow(controller).to receive(:authorize!) { raise ActiveRecord::RecordNotFound }
      get :index, params.merge(user_uid: 'test')
      expect(response.status).to eql 404
    end
  end

  describe '#create' do

  end
end