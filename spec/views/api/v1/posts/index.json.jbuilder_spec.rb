require 'spec_helper'

RSpec.describe 'api/v1/posts/index' do
  let(:user1) { build :user, first_name: 'fn1', last_name: 'ln1', email: 'fn.ln1@gmail.com' }
  let(:post1) { build :post, title: 'title1', content: 'content1', id: 1, user_id: 11 }
  let(:user2) { build :user, first_name: 'fn2', last_name: 'ln2', email: 'fn.ln2@gmail.com' }
  let(:post2) { build :post, title: 'title2', content: 'content2', id: 2, user_id: 22 }

  let(:result) do
    [
      {
        'id' => 1,
        'user_id' => 11,
        'title' => 'title1',
        'first_name' => 'fn1',
        'last_name' => 'ln1',
        'email' => 'fn.ln1@gmail.com',
        'content' => 'content1'
      },
      {
        'id' => 2,
        'user_id' => 22,
        'title' => 'title2',
        'first_name' => 'fn2',
        'last_name' => 'ln2',
        'email' => 'fn.ln2@gmail.com',
        'content' => 'content2'
      }
    ]
  end

  it 'should return correct representation of posts' do
    allow(view).to receive(:records).and_return [ post1, post2 ]
    allow(post1).to receive(:user).and_return user1
    allow(post2).to receive(:user).and_return user2
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end