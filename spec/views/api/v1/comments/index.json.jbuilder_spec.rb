require 'spec_helper'

RSpec.describe 'api/v1/comments/index' do
  let(:user1) { build :user, first_name: 'fn1', last_name: 'ln1', email: 'fn.ln1@gmail.com' }
  let(:comment1) { build :comment, content: 'content1', id: 1, user_id: 11, post_id: 111 }
  let(:user2) { build :user, first_name: 'fn2', last_name: 'ln2', email: 'fn.ln2@gmail.com' }
  let(:comment2) { build :comment, content: 'content2', id: 2, user_id: 22, post_id: 222 }

  let(:result) do
    [
      {
        'id' => 1,
        'user_id' => 11,
        'post_id' => 111,
        'first_name' => 'fn1',
        'last_name' => 'ln1',
        'email' => 'fn.ln1@gmail.com',
        'content' => 'content1'
      },
      {
        'id' => 2,
        'user_id' => 22,
        'post_id' => 222,
        'first_name' => 'fn2',
        'last_name' => 'ln2',
        'email' => 'fn.ln2@gmail.com',
        'content' => 'content2'
      }
    ]
  end

  it 'should return correct representation of comments' do
    allow(view).to receive(:records).and_return [ comment1, comment2 ]
    allow(comment1).to receive(:user).and_return user1
    allow(comment2).to receive(:user).and_return user2
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end