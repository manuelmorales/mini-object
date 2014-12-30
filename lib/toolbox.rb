module MiniObject
  class Tool
    attr_accessor :name

    def initialize name = nil, &block
      @name = name
    end
  end

  class Toolbox
    attr_accessor :name

    def initialize name = nil, &block
      @name = name
      instance_eval &block if block
    end

    def tool name
      tools[name] = Tool.new(name)
    end

    private
    
    def tools
      @tools ||= {}
    end

    def method_missing name, *args
      if tools.has_key? name
        tools[name]
      else
        raise NotImplementedError.new("Undefined method or tool #{name} for toolbox #{self.name.to_s.inspect}")
      end
    end
  end
end
