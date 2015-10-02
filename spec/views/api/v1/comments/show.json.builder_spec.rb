require 'spec_helper'

RSpec.describe 'api/v1/comments/show' do
  let(:user) { build :user, first_name: 'fn', last_name: 'ln', email: 'fn.ln@gmail.com' }
  let(:comment) { build :comment, content: 'content', id: 1, user_id: 2, post_id: 3 }

  let(:result) do
    {
      'id' => 1,
      'user_id' => 2,
      'post_id' => 3,
      'first_name' => 'fn',
      'last_name' => 'ln',
      'email' => 'fn.ln@gmail.com',
      'content' => 'content'
    }
  end

  it 'should return correct representation of comment' do
    allow(view).to receive(:record).and_return comment
    allow(comment).to receive(:user).and_return user
    render template: subject
    expect(JSON.parse(rendered)).to eql result
  end
end