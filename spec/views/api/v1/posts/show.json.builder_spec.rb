require 'spec_helper'

RSpec.describe 'api/v1/posts/show' do
  let(:user) { build :user, first_name: 'fn', last_name: 'ln', email: 'fn.ln@gmail.com' }
  let(:post) { build :post, title: 'title', content: 'content', id: 1, user_id: 2 }

  let(:result) do
    {
      'id' => 1,
      'user_id' => 2,
      'title' => 'title',
      'first_name' => 'fn',
      'last_name' => 'ln',
      'email' => 'fn.ln@gmail.com',
      'content' => 'content'
    }
  end

  it 'should return correct representation of post' do
    allow(view).to receive(:record).and_return post
    allow(post).to receive(:user).and_return user
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end