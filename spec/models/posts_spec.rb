require 'spec_helper'

RSpec.describe Post do
  context 'read only attributes' do
    its('class.readonly_attributes') { should include 'user_id' }
  end

  context 'delegations' do
    it { should respond_to :user_first_name }
    it { should respond_to :user_last_name }
    it { should respond_to :user_email }
  end

  context 'relations' do
    it { should belong_to :user }
    it { should have_many :comments }
  end

  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :title }
    it { should ensure_length_of(:title).is_at_most(255) }
    it { should validate_presence_of :content }
    it { should ensure_length_of(:content).is_at_most(5000) }
  end
end