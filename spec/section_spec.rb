require_relative 'spec_helper'

describe 'Section' do
  subject { Section.new name: 'subject' }

  describe '#section' do
    it 'provides sections' do
      subject.section(:my_section)
      expect{ subject.my_section }.not_to raise_error
      expect(subject.respond_to? :my_section).to eq true
    end

    it 'assigns the name' do
      subject.section(:my_section)
      expect(subject.my_section.name).to eq :my_section
    end

    it 'assigns the parent' do
      subject.section(:my_section){|s| s.section(:my_sub_section) }
      expect(subject.my_section.my_sub_section.parent).to eq subject.my_section
    end

    it 'memoizes the result' do
      target = double('target')
      expect(target).to receive(:a_message).once

      subject.section(:my_section) do
        target.a_message
      end

      subject.my_section
      subject.my_section
    end

    it 'allows nesting' do
      subject.section(:first_level) do |first_level|
        first_level.section :second_level
      end
      
      expect(subject.first_level.second_level).to be_a(Section)
    end

    it 'doesn\'t overwrite if nesting an already existent' do
      subject.section(:a){|s| s.define_singleton_method(:b){ 2 } }
      subject.section(:a){|s| s.define_singleton_method(:c){ 3 } }
      expect(subject.a.b).to eq 2
      expect(subject.a.c).to eq 3
    end
  end

  describe '#root' do
    it 'is the parent with no parent' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.root).to eq subject
    end
  end

  describe '#ancestors' do
    it 'is the the list of parents' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.ancestors).to eq [subject, subject.a]
    end
  end

  describe '#path' do
    it 'is the the list of parents and itself' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.a.b.path).to eq [subject, subject.a, subject.a.b]
    end
  end

  describe '#let' do
    it 'doesn\'t evaluate it at definition time' do
      target = double('target')
      expect(target).not_to receive(:a_message)

      subject.let(:target) do
        target.a_message
        target
      end
    end

    it 'memoizes the result' do
      target = double('target')
      expect(target).to receive(:a_message).once

      subject.let(:target) do
        target.a_message
        target
      end

      subject.target.to_s
      subject.target.to_s
    end

    it 'allows assigning the result' do
      subject.let(:target) { 1 }
      subject.target = 2

      expect(subject.target).to eq 2
    end
  end

  describe 'overriding' do
    it 'is doable going directly to the lazy' do
      require 'ostruct'
      subject.section(:a) do |a|
        a.section(:b) do |b| 
          b.let(:c) { OpenStruct.new }.tap do |c|
            c.build_step(:name) { |c| c.name = 'old_name' }
            c.build_step(:age) { |c| c.age = 'old_age' }
          end
        end
      end

      subject.a.b.c.build_step(:name) { |o| o.name = 'new_name' }

      expect(subject.a.b.c.get_obj.name).to eq 'new_name'
      expect(subject.a.b.c.get_obj.age).to eq 'old_age'
    end
  end

  describe '.new' do
    it 'allows passing a block' do
      subject = Section.new do |s|
        s.section :a do |a|
          a.let(:b) { 2 }
        end
      end

      expect(subject.a).to be_a Section
    end
  end

  describe '#inspect' do
    it 'contains the name of the ancestors' do
      subject.section(:a1){|s| s.section(:b); s.section(:c) }
      subject.section(:a2){|s| s.section(:b); s.section(:c) }
      expect(subject.inspect).to eq <<-TEXT.gsub(/^ {6}/, '').strip
      << subject >>
        < a1 >
          < b >
          < c >
        < a2 >
          < b >
          < c >
      TEXT
    end

    it "contains lets" do
      subject.section(:a) do |s|
        s.section(:b) do |b|
          b.let(:c) { double(inspect: 'inspecting_c') }.tap do |c|
            c.build_step(:step_1) { }
            c.build_step(:step_2) { }
          end
        end
      end

      expect(subject.inspect).to eq <<-TEXT.gsub(/^ {6}/, '').strip
      << subject >>
        < a >
          < b >
            < c: Lazy("b.let(:c) { double(inspect: 'inspecting_c') }.tap do |c|; c.…" step_1, step_2) >
      TEXT
    end
  end

  describe '#to_s' do
    it 'is just the first entry' do
      subject.section(:a){|s| s.section(:b) }
      expect(subject.to_s).to eq '<< subject >>'
    end
  end

  describe '#eval_file' do
    it 'is executed in the scope of the object itself' do
      file = Tempfile.new 'test'
      file.write <<-FILE
        section(:my_section) do |sec|
          sec.let(:value) { object_id }
        end
      FILE
      file.close

      subject.eval_file file.path

      expect(subject.my_section.value).to eq subject.object_id
    end
  end

  describe 'describe' do
    it 'passes the lazy object to the block' do
      subject.describe :test do |t|
        t.build{ [] }
        t.build_step(:add_one) { |a| a << :one }
      end

      expect(subject.test.get_obj).to eq([:one])
    end
  end
end
