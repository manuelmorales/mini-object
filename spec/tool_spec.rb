require_relative 'spec_helper'

describe 'Tool' do
  it 'has a name' do
    tool = Tool.new 'my_name'
    expect(tool.name).to eq 'my_name'
  end

  describe 'subject' do
    it 'is lazy loaded at "get" time' do
      expect(Array).not_to receive(:new)

      tool = Tool.new :array do
        subject { Array.new }
      end
    end

    it 'is memoized' do
      expect(Array).to receive(:new).once.and_return([])

      tool = Tool.new :array do
        subject { Array.new }
      end

      expect(tool.get).to eq []
      expect(tool.get).to eq []
    end

    it 'has a meaningful error message on get and no subject is defined' do
      tool = Tool.new
      expect{ tool.get }.to raise_error(NotImplementedError)
    end
  end
end
