require_relative 'spec_helper'

RSpec.describe 'Resolver' do
  it 'delegates to the result of evaluating the lambda' do
    target = double('target')
    subject = Resolver.new { target }

    expect(target).to receive(:a_method)
    subject.a_method
  end

  it 'will always point to the latest value' do
    target = old_target = double('OLD target')
    subject = Resolver.new { target }

    target = new_target = double('NEW target')
    expect(new_target).to receive(:a_method)

    subject.a_method
  end

  it '#resolver_bound returns the object owner of the binding' do
    subject = Resolver.new { 2 + 2 }
    expect(subject.resolver_bound).to eq self
  end
end
