require 'spec_helper'

RSpec.describe User do
  context 'enum' do
    it { expect(subject).to respond_to :guest? }
    it { expect(subject).to respond_to :user? }
    it { expect(subject).to respond_to :admin? }

    it 'should raise error if not valid role is assigned' do
      expect { subject.role = 'test' }.to raise_error(ArgumentError)
    end

    context 'roles order' do
      it 'should have 0 index for admin role' do
        subject.role = 0
        expect(subject.admin?).to be_true
      end

      it 'should have 1 index for user role' do
        subject.role = 1
        expect(subject.user?).to be_true
      end

      it 'should have 2 index for guest role' do
        subject.role = 2
        expect(subject.guest?).to be_true
      end
    end
  end

  context 'read only attributes' do
    it { expect(described_class._attr_readonly).to include 'uid' }
    it { expect(described_class._attr_readonly).to include 'client_application_id' }
  end

  context 'relations' do
    it { expect(subject).to belong_to :client_application }
    it { expect(subject).to have_many :posts }
    it { expect(subject).to have_many :comments }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of :uid }
    it { expect(subject).to validate_presence_of :role }
    it { expect(subject).to validate_presence_of :client_application }
  end

  context 'class_methods' do
    subject { User }

    describe '#guest' do
      it 'should return new user with guest role' do
        expect(subject.guest.guest?).to be_true
      end
    end
  end
end