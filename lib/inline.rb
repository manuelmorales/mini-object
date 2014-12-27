module MiniObject
  class Inline
    require 'injectable'
    include Injectable

    attr_accessor :inline_name

    def initialize name = nil, &block
      @inline_name = name || 'inline'
      instance_exec self, &block if block
    end
  end
end
