require 'spec_helper'

RSpec.describe Comment do
  context 'read only attributes' do
    its('class.readonly_attributes') { should include 'user_id' }
    its('class.readonly_attributes') { should include 'post_id' }
  end

  context 'delegations' do
    it { should respond_to :user_first_name }
    it { should respond_to :user_last_name }
    it { should respond_to :user_email }
  end

  context 'relations' do
    it { should belong_to :post }
    it { should belong_to :user }
  end

  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :post }
    it { should validate_presence_of :content }
    it { should ensure_length_of(:content).is_at_most(255) }
  end
end