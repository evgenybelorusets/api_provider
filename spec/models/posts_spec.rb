require 'spec_helper'

RSpec.describe Post do
  context 'read only attributes' do
    it { expect(described_class._attr_readonly).to include 'user_id' }
  end

  context 'delegations' do
    it { expect(subject).to respond_to :user_first_name }
    it { expect(subject).to respond_to :user_last_name }
    it { expect(subject).to respond_to :user_email }
  end

  context 'relations' do
    it { expect(subject).to belong_to :user }
    it { expect(subject).to have_many :comments }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of :user }
    it { expect(subject).to validate_presence_of :title }
    it { expect(subject).to ensure_length_of(:title).is_at_most(255) }
    it { expect(subject).to validate_presence_of :content }
    it { expect(subject).to ensure_length_of(:content).is_at_most(5000) }
  end
end