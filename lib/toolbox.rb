module MiniObject
  class Toolbox
    attr_accessor :name

    def initialize name = nil, &block
      @name = name
      instance_eval &block if block
    end

    def box name, &block
      if block
        set_box name, &block
      else
        get_box name
      end
    end

    def tool name, &block
      if block
        set_tool name, &block
      else
        get_tool name
      end
    end

    def eval_file path
      instance_eval File.read(path), path
    end

    private

    def tools
      @tools ||= {}
    end

    def boxes
      @boxes ||= {}
    end

    def set_tool name, &block
      tools[name] = Tool.new(name, &block)
    end

    def get_tool name
      tools[name] || not_found!(name)
    end

    def set_box name, &block
      boxes[name] = self.class.new(name, &block)
    end

    def get_box name
      boxes[name] || not_found!(name)
    end

    def method_missing name, *args
      if tools.has_key? name
        tools[name].get
      elsif boxes.has_key? name
        boxes[name]
      else
        not_found!(name)
      end
    end

    def respond_to_missing? name, *args
      !!(tools[name] || boxes[name])
    end

    def not_found! name
      raise NotImplementedError.new("Undefined method #{name} for toolbox #{self.inspect}")
    end
  end
end
