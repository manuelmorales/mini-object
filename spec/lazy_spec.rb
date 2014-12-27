require_relative 'spec_helper'

RSpec.describe 'Lazy' do
  let(:klass) { double('class', new: instance) }
  let(:instance) { double('instance', a_method: 'a_result') }

  it 'forwards messages to the result of the lambda' do
    subject = Lazy.new{ klass.new }
    expect(subject.a_method).to eq('a_result')
  end

  it 'is lazy' do
    expect(klass).not_to receive(:new)
    subject = Lazy.new{ klass.new }
  end

  it 'memoizes the result' do
    expect(klass).to receive(:new).once
    subject = Lazy.new{ klass.new }

    subject.a_method
    subject.a_method
  end

  describe 'inspect' do
    it 'has the source code' do
      subject = Lazy.new { klass.new }
      expect(subject.inspect).to match('klass.new')
    end

    it 'has a name' do
      subject = Lazy.new('The Subject') { klass.new }
      expect(subject.inspect).to match('The Subject')
    end

    it 'doesn\'t have the name when blank' do
      subject = Lazy.new { klass.new }
      expect(subject.inspect).to match('< Lazy')
    end

    it 'is aliased as to_s' do
      subject = Lazy.new { klass.new }
      expect(subject.to_s).to match('klass.new')
    end
  end

  describe 'build_steps' do
    it 'invokes them at build time' do
      subject = Lazy.new { [] }
      subject.build_step(:add_one) { |array| array << 1 }

      expect(subject.get_obj).to eq([1])
    end

    it 'allows substituting them' do
      subject = Lazy.new { [] }
      subject.build_step(:add_one) { |array| array << 1 }
      subject.build_step(:add_one) { |array| array << :one }

      expect(subject.get_obj).to eq([:one])
    end
  end
end
