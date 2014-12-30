require_relative 'spec_helper'

describe 'Tool' do
  subject { Toolbox.new name: 'subject' }

  it 'has a name' do
    subject = Toolbox.new 'my_name'
    expect(subject.name).to eq 'my_name'
  end

  describe 'tools' do
    it 'can be defined at initialization' do
      subject = Toolbox.new do
        tool :db_connection
      end

      expect(subject.db_connection.name).to eq(:db_connection)
    end
  end

  it 'provides a meaningful method not found exeception' do
    expect{ subject.asdasdad }.to raise_error(NotImplementedError)
  end
end
