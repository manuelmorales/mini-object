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
        tool(:db_connection) { }
      end

      expect(subject.tool(:db_connection).name).to eq(:db_connection)
    end

    it 'passes the initalization block to the tool' do
      the_connection = double('a db connection') 

      subject = Toolbox.new do
        tool :db_connection do
          the_connection
        end
      end

      expect(subject).to respond_to :db_connection
      expect(subject.db_connection).to be the_connection
    end

    it 'raises an exception when no tool is found' do
      expect{ subject.tool(:adadsaad) }.to raise_error(NotImplementedError)
    end
  end

  describe 'boxes' do
    it 'can be defined at initialization' do
      subject = Toolbox.new do
        box(:controllers) { }
      end

      expect(subject).to respond_to :controllers
      expect(subject.controllers.name).to eq(:controllers)
    end

    it 'passes the initalization block to the box' do
      mysql = []

      subject = Toolbox.new do
        box :dbs do
          box :persistent do
            tool :mysql do
              mysql << some_definition
            end
            tool(:mysql).define(:some_definition) { :some }
          end
        end
      end

      expect(subject.dbs.persistent.mysql).to eq [:some]
    end

    it 'raises an exception when no box is found' do
      expect{ subject.box(:adadsaad) }.to raise_error(NotImplementedError)
    end
  end

  it 'provides a meaningful method not found exeception' do
    expect{ subject.asdasdad }.to raise_error(NotImplementedError)
  end

  it 'evaluates files' do
    file = Tempfile.new 'test'
    file.write <<-FILE
      box :dbs do
        tool(:mysql){ :mysql_database }
      end
    FILE
    file.close

    subject.eval_file file.path

    expect(subject.dbs.mysql).to eq :mysql_database
  end

  it 'has a root'
end
