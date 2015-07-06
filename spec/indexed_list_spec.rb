require_relative 'spec_helper'
require 'ostruct'

RSpec.describe 'IndexedList' do
  let(:subject_class) { MiniObject::IndexedList }

  let(:subject_instance) do
    subject_class.new.tap do |l|
      l.key {|e| e.name }
      l.build { OpenStruct.new }
    end
  end

  subject { subject_instance }

  it 'accumulates values with <<' do
    value = double('value', name: 'Value 1')
    subject << value
    expect(subject['Value 1']).to be value
  end

  it 'accumulates values with add' do
    value = double('value', name: 'Value 1')
    subject.add value
    expect(subject['Value 1']).to be value
  end

  it 'adds new values' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    expect(subject['Value 1']).to be value
  end

  it 'iterates through values' do
    has_run = false

    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    subject.each do |e|
      has_run = true
      expect(e).to be value
    end
  end

  it 'converts to array' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    expect(subject.to_a).to eq [value]
  end

  it 'clears' do
    value = subject.add_new do |e|
      e.name = 'Value 1'
    end

    subject.clear

    expect(subject.to_a).to eq []
  end

  it 'merges' do
    subject_2 = subject_class.new.tap do |l|
      l.key {|e| e.name }
      l.build { OpenStruct.new }
    end

    value_1 = subject.add_new do |v|
      v.name = 1
    end

    value_2 = subject_2.add_new do |v|
      v.name = 2
    end

    expect(subject.merge(subject_2).to_a).to eq [value_1, value_2]
  end

  it 'merges without altering the original' do
    subject_2 = subject_class.new.tap do |l|
      l.key {|e| e.name }
      l.build { OpenStruct.new }
    end

    value_1 = subject.add_new do |v|
      v.name = 1
    end

    value_2 = subject_2.add_new do |v|
      v.name = 2
    end

    subject.merge(subject_2).to_a
    expect(subject.to_a).to eq [value_1]
  end
end
