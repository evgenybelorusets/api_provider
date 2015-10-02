require 'spec_helper'

RSpec.describe User do
  context 'enum' do
    it { should respond_to :guest? }
    it { should respond_to :user? }
    it { should respond_to :admin? }

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

  context 'relations' do
    it { should belong_to :client_application }
    it { should have_many :posts }
    it { should have_many :comments }
  end

  context 'validations' do
    it { should validate_presence_of :uid }
    it { should validate_presence_of :role }
    it { should validate_presence_of :client_application }
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