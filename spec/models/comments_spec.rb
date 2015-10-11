require 'spec_helper'

RSpec.describe Comment do
  context 'read only attributes' do
    it { expect(described_class._attr_readonly).to include 'user_id' }
    it { expect(described_class._attr_readonly).to include 'post_id' }
  end

  context 'delegations' do
    it { expect(subject).to respond_to :user_first_name }
    it { expect(subject).to respond_to :user_last_name }
    it { expect(subject).to respond_to :user_email }
  end

  context 'relations' do
    it { expect(subject).to belong_to :post }
    it { expect(subject).to belong_to :user }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of :user }
    it { expect(subject).to validate_presence_of :post }
    it { expect(subject).to validate_presence_of :content }
    it { expect(subject).to ensure_length_of(:content).is_at_most(255) }
  end
end