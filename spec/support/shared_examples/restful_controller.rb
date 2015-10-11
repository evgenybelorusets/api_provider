RSpec.shared_examples 'RESTful controller' do |params = {}|
  action_params = params.merge user_uid: 'test', format: :json
  record_action_params = action_params.merge(id: 1)

  context 'rescue from' do
    it_behaves_like 'rescueable controller', :get, :index, action_params
    it_behaves_like 'rescueable controller', :get, :show, record_action_params
    it_behaves_like 'rescueable controller', :post, :create, action_params
    it_behaves_like 'rescueable controller', :put, :update, record_action_params
    it_behaves_like 'rescueable controller', :delete, :destroy, record_action_params
  end

  context 'actions' do
    let(:errors) { { some: :errors } }
    let(:record) { double :record, errors: errors, save: nil, update_attributes: nil, destroy: nil }
    let(:records) { double :records }
    let(:record_class) { double :record_class }
    let(:record_params) { double :record_params }

    before :each do
      allow(subject).to receive(:record_params).and_return record_params
      allow(subject).to receive(:authorize!)
      allow(subject).to receive(:record).and_return record
      allow(subject).to receive(:records).and_return records
      allow(subject).to receive(:record_class).and_return record_class
    end

    describe '#create' do
      it 'should authorize ability to create record' do
        expect(subject).to receive(:authorize!).with(:create, record_class)
        post :create, action_params
      end

      it 'should save record and render show with HTTP 201 status if save was successful' do
        allow(record).to receive(:save).and_return true
        post :create, action_params
        expect(response.status).to eql 201
        expect(response).to render_template('show')
      end

      it 'should save record and render errors with HTTP 422 status if save was not successful' do
        allow(record).to receive(:save).and_return false
        post :create, action_params
        expect(response.status).to eql 422
        expect(JSON.parse(response.body)).to eql('errors' => { 'some' => 'errors' })
      end
    end

    describe '#update' do
      it 'should authorize ability to update record' do
        expect(subject).to receive(:authorize!).with(:update, record)
        put :update, record_action_params
      end

      it 'should update record with new params and render show with HTTP 200 status if save was successful' do
        allow(record).to receive(:update_attributes).with(record_params ).and_return true
        put :update, record_action_params
        expect(response.status).to eql 200
        expect(response).to render_template('show')
      end

      it 'should update record with new params and render errors with HTTP 422 status if save was not successful' do
        allow(record).to receive(:update_attributes).with(record_params ).and_return
        put :update, record_action_params
        expect(response.status).to eql 422
        expect(JSON.parse(response.body)).to eql('errors' => { 'some' => 'errors' })
      end
    end

    describe '#index' do
      it 'should authorize ability to read records' do
        expect(subject).to receive(:authorize!).with(:read, record_class)
        get :index, action_params
      end

      it 'should render index template' do
        get :index, action_params
        expect(response).to render_template('index')
      end
    end

    describe '#show' do
      it 'should authorize ability to read record' do
        expect(subject).to receive(:authorize!).with(:read, record)
        get :show, record_action_params
      end

      it 'should render show template' do
        get :show, record_action_params
        expect(response).to render_template('show')
      end
    end

    describe '#destroy' do
      it 'should authorize ability to destroy record' do
        expect(subject).to receive(:authorize!).with(:destroy, record)
        delete :destroy, record_action_params
      end

      it 'should destroy record and return empty response with 204 status' do
        expect(record).to receive(:destroy)
        delete :destroy, record_action_params
        expect(response.status).to eql 204
        expect(response.body).to eql ''
      end
    end
  end
end