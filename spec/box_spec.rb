require_relative 'spec_helper'
require 'box'

describe 'Box' do
  it 'allows nested boxes' do

    stub_const 'Stores', Class.new(Box) {
      def memory
        :memory_store
      end
    }

    stub_const 'BoxApp', Class.new(Box) {
      def stores
        @stores ||= Stores.new
      end
    }

    expect(BoxApp.new.stores.memory).to eq :memory_store
  end

  it 'allows tools requiring a config' do

    stub_const 'Stores', Class.new(Box) {
      attr_accessor :config

      def hash; {}; end
      def array; []; end

      def default
        case config[:default]
        when 'array' then array
        when 'hash' then hash
        end
      end
    }

    stub_const 'Config', Class.new(Box) {
      def stores
        @stores ||= { default: 'hash' }
      end
    }

    stub_const 'BoxApp', Class.new(Box) {
      def stores
        @stores ||= Stores.new config: config.stores
      end

      def config
        @config ||= Config.new
      end
    }

    subject = BoxApp.new
    expect(subject.stores.default).to eq({})

    subject.config.stores[:default] = 'array'
    expect(subject.stores.default).to eq([])
  end

  it 'allows overriding a tool' do

    stub_const 'BoxApp', Class.new(Box) {
      attr_accessor :store

      def store
        @store ||= :memory
      end
    }

    subject = BoxApp.new
    expect(subject.store).to be :memory

    subject.store = :persistent
    expect(subject.store).to be :persistent
  end

  it 'allows overriding config files with inheritance' do
    stub_const 'Defaults', { persistent: true, adapter: 'mysql' }
    stub_const 'Overrides',  { adapter: 'postgres' }

    stub_const 'Conf', Class.new(Box) {
      def db
        @db ||= Defaults.merge db_overrides
      end

      def db_overrides
        {}
      end
    }

    stub_const 'BoxApp', Class.new(Box) {
      def config
        @config ||= Conf.new
      end
    }

    stub_const 'TestConf', Class.new(Conf) {
      def db_overrides
        Overrides
      end
    }

    stub_const 'TestBoxApp', Class.new(BoxApp) {
      def config
        @config ||= TestConf.new
      end
    }

    expect(BoxApp.new.config.db).to eq({ persistent: true, adapter: 'mysql' })
    expect(TestBoxApp.new.config.db).to eq({ persistent: true, adapter: 'postgres' })
  end

  it 'looks pretty' do
    stub_const 'BoxApp', Class.new(Box){
      def config; end
      def stores; end
    }

    subject = BoxApp.new

    expect(BoxApp.to_s).to eq('BoxApp')
    expect(subject.to_s).to eq('< BoxApp : config, stores >')

    expect(BoxApp.inspect).to eq('BoxApp( config, stores )')
    expect(subject.inspect).to eq('< BoxApp : config, stores >')
  end
end
