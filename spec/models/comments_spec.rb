require 'spec_helper'

RSpec.describe Comment do
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