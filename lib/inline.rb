module MiniObject
  class Inline
    require 'injectable'
    include Injectable

    attr_accessor :inline_name

    def initialize name = nil, &block
      @inline_name = name || 'inline'
      instance_exec self, &block if block
    end

    def inspect
      "< #{self.class.name}: #{(methods - self.class.instance_methods).join(", ")} >"
    end

    alias to_s inspect

    # TODO: Explore the possiblity of allowing access to methods and 
    # vars defined outside the block.
  end
end
