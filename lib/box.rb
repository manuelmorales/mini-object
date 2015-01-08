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

    def to_s
      "< #{self.class.name} : #{remarkable_methods.join(", ")} >"
    end

    alias inspect to_s

    def self.inspect
      "#{formatted_name}( #{remarkable_methods.join(", ")} )"
    end

    private

    def self.remarkable_methods
      (self.instance_methods - Box.instance_methods).map(&:to_s).tap do |mm|
        # Substittues [my_method, my_method=] by [my_method/=]
        mm.grep(/\=$/).each do |setter|
          getter = setter.gsub /\=$/, ''
          if mm.include? getter
            mm.delete setter
            mm[mm.find_index(getter)] = setter.gsub /\=$/, '/='
          end
        end
      end
    end

    def remarkable_methods
      self.class.remarkable_methods
    end

    def self.formatted_name
      first_ancestor_name = ancestors.map(&:name).compact.first
      name || "#{first_ancestor_name}:0x#{'%x' % (object_id << 1)}"
    end
  end
end
