require_relative '../spec_helper'
require 'mini_object/injectable'

RSpec.describe 'Injectable' do
  shared_examples_for 'having an injectable name' do
    it 'provides getter and setter' do
      expect(subject.name = 'A name').to eq 'A name'
      expect(subject.name).to eq 'A name'
    end

    it 'allows setting a value without the = sign' do
      expect(subject.name 'A name').to eq 'A name'
      expect(subject.name).to eq 'A name'
    end

    it 'allows setting nil' do
      subject.name = 'A name'
      expect(subject.name nil).to eq nil
      expect(subject.name).to eq nil
    end

    it 'allows setting a value with a lambda' do
      subject.name { 'A name' }
      expect(subject.name).to eq 'A name'
    end

    it 'does not memoize the lambda' do
      counter = 0
      subject.name { counter += 1 }
      expect(subject.name).to eq 1
      expect(subject.name).to eq 2
    end

    it 'gives priority to the value if both, block and value == nil are given' do
      subject.name('value'){ 'block' }
      expect(subject.name).to eq('value')

      subject.name(nil) { 'block' }
      expect(subject.name).to eq('block')
    end
  end

  context 'attr_accessor within a class' do
    let(:subject_class) do
      Class.new do
        include Injectable
        attr_injectable :name
      end
    end

    subject { subject_class.new }
    it_behaves_like 'having an injectable name'

    it 'allows giving a default' do
      subject_class.class_eval do
        a_surname = 'Smith'
        attr_injectable(:surname) { a_surname }
      end

      expect(subject.surname).to eq 'Smith'
    end
  end

  context 'cattr_accessor within a class' do
    let(:subject_class) do
      Class.new do
        include Injectable
        cattr_injectable :name
      end
    end

    subject { subject_class }
    it_behaves_like 'having an injectable name'

    it 'delegates getter to the class' do
      subject_class.class_eval do
        cattr_injectable :surname
      end
        
      subject_class.surname = 'John'
      expect(subject_class.new.surname).to eq 'John'
    end
  end

  describe '#attributes=' do
    let(:subject_class) do
      Class.new do
        include Injectable
        cattr_injectable :name
      end
    end

    it 'assings each attr' do
      subject = subject_class
      subject.attributes=({ name: 'MyName' })
      expect(subject.name).to eq 'MyName'
    end
  end
end
