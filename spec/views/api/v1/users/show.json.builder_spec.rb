require 'spec_helper'

RSpec.describe 'api/v1/users/show' do
  let(:user) { build :user, id: 1, uid: 'uid', first_name: 'fn', last_name: 'ln', email: 'fn.ln@gmail.com', role: 'user' }
  let(:result) do
    {
      'id' => 1,
      'uid' => 'uid',
      'first_name' => 'fn',
      'last_name' => 'ln',
      'email' => 'fn.ln@gmail.com',
      'role' => 'user'
    }
  end

  it 'should return correct representation of user' do
    allow(view).to receive(:record).and_return user
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end