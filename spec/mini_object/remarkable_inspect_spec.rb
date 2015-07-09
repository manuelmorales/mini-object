require_relative '../spec_helper'

RSpec.describe 'RemarkableInspect' do
  subject { SubjectClass.new }

  before do
    stub_const 'SubjectClass', Class.new {
      include RemarkableInspect

      def config; end
      def config=; end
      def stores; end
    }
  end

  describe '#to_s' do
    it 'contains class name and class specific methods' do
      expect(subject.to_s).to eq('< SubjectClass : config/=, stores >')
    end
  end

  describe '#inspect' do
    it 'contains class name and class specific methods' do
      expect(subject.inspect).to eq('< SubjectClass : config/=, stores >')
    end
  end

  describe '.to_s' do
    it 'contains just the class name' do
      expect(SubjectClass.to_s).to eq('SubjectClass')
    end
  end

  describe '.inspect' do
    it 'contains class name and class specific methods' do
      expect(SubjectClass.inspect).to eq('SubjectClass( config/=, stores )')
    end

    it 'contains the object hash in anonymous classes' do
      expect(Class.new(SubjectClass).inspect).to match(/SubjectClass:0x.*\( config\/=, stores \)/)
    end
  end
end
