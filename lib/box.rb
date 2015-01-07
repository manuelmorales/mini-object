module MiniObject
  class Box
    def initialize attrs = {}
      self.attributes= attrs
    end

    def attributes= attrs
      attrs.each do |k,v|
        public_send "#{k}=", v
      end
    end

    def self.let name, &block
      attr_accessor name

      define_method name do
        var = :"@#{name}"

        instance_variable_get(var) || 
          instance_variable_set(var, dsl.evaluate(&block))
      end
    end

    def self.evaluates name, &block
      define_method name do
        dsl.evaluate(&block)
      end
    end

    def to_s
      "< #{self.class.name} : #{added_methods.join(", ")} >"
    end

    alias inspect to_s

    def self.inspect
      "#{name}( #{added_methods.join(", ")} )"
    end

    private

    def dsl
      ForwardingDSL.new(self, *added_methods)
    end

    def self.added_methods
      self.instance_methods - Box.instance_methods
    end

    def added_methods
      self.class.added_methods
    end
  end
end
