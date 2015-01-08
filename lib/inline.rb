module MiniObject
  class Inline
    include Injectable
    include RemarkableInspect

    attr_accessor :inline_name

    def initialize name = nil, &block
      @inline_name = name || 'inline'
      instance_exec self, &block if block
    end

    def remarkable_methods
      methods - self.class.instance_methods
    end

    def remarkable_name
      "#{inline_name || 'anon'} / Inline"
    end

    # TODO: Explore the possiblity of allowing access to methods and 
    # vars defined outside the block.
  end
end
