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

    it 'allows using just tool at initialization time'
    it 'responds to the method with such name'
  end

  describe 'boxes' do
    it 'can be defined at initialization' do
      subject = Toolbox.new do
        add_box :controllers
      end

      expect(subject.controllers.name).to eq(:controllers)
    end

    it 'passes the initalization block to the box' do
      mysql = double('a db connection') 

      subject = Toolbox.new do
        add_box :dbs do
          add_box :persistent do
            add_tool :mysql do
              subject { mysql }
            end
          end
        end
      end

      expect(subject.dbs.persistent.mysql).to be mysql
    end
  end

  it 'provides a meaningful method not found exeception' do
    expect{ subject.asdasdad }.to raise_error(NotImplementedError)
  end
end
