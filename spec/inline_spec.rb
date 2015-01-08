require_relative 'spec_helper'

RSpec.describe 'Inline' do
  it 'allows defining methods with an initialization block' do
    subject = Inline.new do
      def bark
        'woof'
      end
    end

    expect(subject.bark).to eq('woof')
  end

  it 'has an inspect and to_s' do
    subject = Inline.new 'some name' do
      def bark
        'woof'
      end

      def sleep
        'zzz'
      end
    end

    expect(subject.inspect).to eq("< some name / Inline : bark, sleep >")
    expect(subject.to_s).to eq("< some name / Inline : bark, sleep >")
  end
end
