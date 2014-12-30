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
        Array.new
      end
    end

    it 'is memoized' do
      expect(Array).to receive(:new).once.and_return([])

      tool = Tool.new :array do
        Array.new
      end

      expect(tool.get).to eq []
      expect(tool.get).to eq []
    end

    it 'has a meaningful error message on get and no subject is defined' do
      tool = Tool.new
      expect{ tool.get }.to raise_error(NotImplementedError)
    end

    it 'allows defining instance methods' do
      a_piece = double('a piece')

      tool = Tool.new :array do
        [piece]
      end
      tool.define(:piece) { a_piece }

      expect(tool.get).to eq [a_piece]
    end

    it 'allows overriding old methods with new methods' do
      tool = Tool.new :array do
        [piece]
      end

      tool.define(:piece) { :original_piece }
      tool.define(:piece) { :new_piece }

      expect(tool.get).to eq [:new_piece]
    end
  end

  it 'has a root'
end
