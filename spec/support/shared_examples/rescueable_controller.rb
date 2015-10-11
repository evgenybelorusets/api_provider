RSpec.shared_examples 'rescueable controller' do |action_method, action_name, action_params = {}|
  let(:record) { double :record }
  let(:record_class) { double :record_class }

  before :each do
    allow(subject).to receive(:record).and_return record
    allow(subject).to receive(:record_class).and_return record_class
  end

  it "should render response with 403 HTTP status if action #{action_name} raised CanCan::AccessDenied" do
    allow(controller).to receive(:authorize!) { raise CanCan::AccessDenied }
    send action_method, action_name, action_params
    expect(response.status).to eql 403
  end

  it "should render response with 403 HTTP status if action #{action_name} raised ActiveRecord::RecordNotFound" do
    allow(controller).to receive(:authorize!) { raise ActiveRecord::RecordNotFound }
    send action_method, action_name, action_params
    expect(response.status).to eql 404
  end
end