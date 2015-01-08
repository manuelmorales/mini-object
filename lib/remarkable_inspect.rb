module MiniObject
  module RemarkableInspect
    def to_s
      "< #{remarkable_name} : #{remarkable_methods.join(", ")} >"
    end

    alias inspect to_s

    def self.included klass
      klass.extend ClassMethods
    end

    private

    def remarkable_methods
      self.class.remarkable_methods
    end

    def remarkable_name
      self.class.name
    end

    module ClassMethods
      def inspect
        "#{formatted_name}( #{remarkable_methods.join(", ")} )"
      end

      def remarkable_methods
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

      def formatted_name
        first_ancestor_name = ancestors.map(&:name).compact.first
        name || "#{first_ancestor_name}:0x#{'%x' % (object_id << 1)}"
      end
    end
  end
end
