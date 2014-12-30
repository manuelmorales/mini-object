module MiniObject
  class Tool
    include Injectable

    attr_accessor :name
    attr_injectable :subject

    def initialize name = nil, &block
      @name = name
      instance_eval &block if block
    end

    def get
      subject
    end
  end

  class Toolbox
    attr_accessor :name

    def initialize name = nil, &block
      @name = name
      instance_eval &block if block
    end

    def add_tool name, &block
      tools[name] = Tool.new(name, &block)
    end

    def add_box name, &block
      boxes[name] = self.class.new(name, &block)
    end

    def tool name
      tools[name]
    end

    private

    def tools
      @tools ||= {}
    end

    def boxes
      @boxes ||= {}
    end

    def method_missing name, *args
      if tools.has_key? name
        tools[name].get
      elsif boxes.has_key? name
        boxes[name]
      else
        raise NotImplementedError.new("Undefined method or tool #{name} for toolbox #{self.name.to_s.inspect}")
      end
    end
  end
end
