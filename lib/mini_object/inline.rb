module MiniObject
  class Inline
    include Injectable
    include RemarkableInspect

    attr_accessor :inline_name

    def initialize name = nil, args = {}, &block
      args.each do |k,v|
        define_singleton_method(k) { v }
      end

      @inline_name = name || 'inline'
      instance_exec self, &block if block
    end

    def remarkable_methods
      (methods - self.class.instance_methods).sort
    end

    def remarkable_name
      "#{inline_name || 'anon'} / Inline"
    end
  end
end
