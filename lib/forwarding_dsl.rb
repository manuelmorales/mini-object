module MiniObject
  class ForwardingDSL
    include Forwardable

    attr_reader :__getobj__

    def initialize obj, *delegates
      @__getobj__ = obj

      delegates.each do |name|
        def_delegator :@__getobj__, name
      end
    end

    def evaluate &block
      @self_before_instance_eval = eval "self", block.binding
      instance_eval &block
    end

    def method_missing(method, *args, &block)
      @self_before_instance_eval.send method, *args, &block
    end
  end
end
