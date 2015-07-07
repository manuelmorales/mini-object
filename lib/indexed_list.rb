require 'forwarding_dsl'

module MiniObject
  class IndexedList
    include Enumerable

    def initialize
      @store = {}
    end

    def key &block
      @key_proc = block
    end

    def build &block
      @build_proc = block
    end

    def << e
      store[key_for(e)] = e
    end

    alias add <<

    def add_new &block
      e = build_new
      ForwardingDsl.run e, &block
      add e
    end

    def [] key
      store.values.detect {|e| key_for(e) == key }
    end

    def each &block
      store.values.each &block
    end

    def clear
      store.clear
    end

    def merge other
      new = dup

      other.each do |v|
        new << v
      end

      new
    end

    def initialize_dup(source)
      @store = store.dup
      super
    end

    def last
      store.values.last
    end

    private

    def store
      @store
    end

    def key_for e
      @key_proc.call e
    end

    def build_new *args
      @build_proc.call *args
    end
  end
end
