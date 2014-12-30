require_relative 'spec_helper'

describe 'Toolbox' do
  subject { Toolbox.new name: 'subject' }

  it 'has a name' do
    subject = Toolbox.new 'my_name'
    expect(subject.name).to eq 'my_name'
  end

  describe 'tools' do
    it 'can be defined at initialization' do
      subject = Toolbox.new do
        add_tool :db_connection
      end

      expect(subject.tool(:db_connection).name).to eq(:db_connection)
    end

    it 'passes the initalization block to the tool' do
      the_connection = double('a db connection') 

      subject = Toolbox.new do
        add_tool :db_connection do
          subject { the_connection }
        end
      end

      expect(subject.db_connection).to be the_connection
    end
  end

  it 'provides a meaningful method not found exeception' do
    expect{ subject.asdasdad }.to raise_error(NotImplementedError)
  end
end
