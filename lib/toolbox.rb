module MiniObject
  class Toolbox
    attr_accessor :name
    attr_accessor :parent

    def initialize name = nil, attrs = {}, &block
      attrs.each do |k,v|
        send "#{k}=", v
      end

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

    def ancestors
      parent ? (parent.ancestors + [parent]) : []
    end

    def root
      ancestors.first
    end

    def to_s
      "< #{name}: #{(boxes.keys + tools.keys).join(", ")} >"
    end

    alias inspect to_s

    private

    def tools
      @tools ||= {}
    end

    def boxes
      @boxes ||= {}
    end

    def set_tool name, &block
      tools[name] = Tool.new(name, parent: self, &block)
    end

    def get_tool name
      tools[name] || not_found!(name)
    end

    def set_box name, &block
      boxes[name] = self.class.new(name, parent: self, &block)
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
        no_method! name
      end
    end

    def respond_to_missing? name, *args
      !!(tools[name] || boxes[name])
    end

    def no_method! name
      raise NoMethodError.new("Undefined method #{name} for toolbox #{self.inspect}")
    end

    def not_found! name
      raise NotImplementedError.new("No tool or box #{name} found for toolbox #{self.inspect}")
    end
  end
end
