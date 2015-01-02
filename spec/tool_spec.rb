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
        define(:piece) { a_piece }
        [piece]
      end

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

  it 'has a parent' do
    subject = Toolbox.new do
      box :dbs do
        tool :mysql do
        end
      end
    end

    expect(subject.dbs.tool(:mysql).parent).to be subject.dbs
  end

  it 'has ancestors' do
    subject = Toolbox.new :root do
      box :dbs do
        box :persistent do
          tool :mysql do
          end
        end
      end
    end

    expect(subject.dbs.persistent.tool(:mysql).ancestors).to eq [subject, subject.dbs, subject.dbs.persistent]
  end

  it 'has a root' do
    subject = Toolbox.new :root do
      box :dbs do
        box :persistent do
          tool :mysql do
          end
        end
      end
    end

    expect(subject.dbs.persistent.tool(:mysql).root).to be subject
  end

  def external_method
    :external_result
  end

  it 'allows calling methods defined outised the block' do
    subject = Toolbox.new :root do
      box :dbs do
        box :persistent do
          tool :mysql do
            external_method
          end
        end
      end
    end

    expect(subject.dbs.persistent.mysql).to be :external_result
  end
end
