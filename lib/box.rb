module MiniObject
  class Box
    def to_s
      "< #{self.class.name} : #{(self.methods - Box.instance_methods).join(", ")} >"
    end

    alias inspect to_s

    def self.inspect
      "#{name}( #{(self.instance_methods - Box.instance_methods).join(", ")} )"
    end
  end
end
