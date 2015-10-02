require 'spec_helper'

RSpec.describe 'api/v1/users/index' do
  let(:user1) { build :user, id: 1, uid: 'uid1', first_name: 'fn1', last_name: 'ln1', email: 'fn.ln1@gmail.com', role: 'user' }
  let(:user2) { build :user, id: 2, uid: 'uid2', first_name: 'fn2', last_name: 'ln2', email: 'fn.ln2@gmail.com', role: 'admin' }
  let(:result) do
    [
      {
        'id' => 1,
        'uid' => 'uid1',
        'first_name' => 'fn1',
        'last_name' => 'ln1',
        'email' => 'fn.ln1@gmail.com',
        'role' => 'user'
      },
      {
        'id' => 2,
        'uid' => 'uid2',
        'first_name' => 'fn2',
        'last_name' => 'ln2',
        'email' => 'fn.ln2@gmail.com',
        'role' => 'admin'
      }
    ]
  end

  it 'should return correct representation of users' do
    allow(view).to receive(:records).and_return [ user1, user2 ]
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end