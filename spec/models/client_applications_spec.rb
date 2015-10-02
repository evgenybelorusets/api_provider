require 'spec_helper'

RSpec.describe ClientApplication do
  context 'relations' do
    it { should have_many :users }
  end

  describe '#generate_http_basic_credentials' do
    let(:relation1) { double :relation1, exists?: true }
    let(:relation2) { double :relation2, exists?: false }

    it 'should generate key and secret until pair is unique' do
      expect(SecureRandom).to receive(:hex).with(16).and_return 'key1'
      expect(SecureRandom).to receive(:hex).with(16).and_return 'secret1'
      expect(ClientApplication).to receive(:where).with(key: 'key1', secret: 'secret1').and_return relation1
      expect(SecureRandom).to receive(:hex).with(16).and_return 'key2'
      expect(SecureRandom).to receive(:hex).with(16).and_return 'secret2'
      expect(ClientApplication).to receive(:where).with(key: 'key2', secret: 'secret2').and_return relation2
      subject.send :generate_http_basic_credentials
      expect(subject.key).to eql 'key2'
      expect(subject.secret).to eql 'secret2'
    end
  end
end
