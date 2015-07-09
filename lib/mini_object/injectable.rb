module MiniObject
  module Injectable
    NULL = Object.new

    def initialize &block
      super
      block.call self if block
    end

    def self.included klass
      klass.extend self
    end

    def self.getsetter_definition_for name
      lambda do |value = NULL, &block|
        if block
          if value == NULL || value == nil
            instance_variable_set("@#{name}_proc", block)
          else
            send("#{name}=", value)
          end
        else
          if value == NULL
            p = instance_variable_get("@#{name}_proc") ||
              self.class.instance_variable_get("@#{name}_default_proc") ||
              raise("No #{name} defined yet for #{inspect}")
            p.call
          else
            send("#{name}=", value)
          end
        end
      end
    end

    def self.setter_definition_for name
      lambda do |value|
        instance_variable_set("@#{name}_proc", lambda{ value })
        value
      end
    end

    def cattr_injectable name, &block
      define_singleton_method name, &Injectable.getsetter_definition_for(name)
      define_singleton_method "#{name}=", &Injectable.setter_definition_for(name)
      send(name, &block) if block
    end

    def attr_injectable name, &block
      define_method name, &Injectable.getsetter_definition_for(name)
      define_method "#{name}=", &Injectable.setter_definition_for(name)
      instance_variable_set("@#{name}_default_proc", block) if block
    end

    def let name, &block
      var_name = :"@#{name}"

      define_singleton_method "#{name}=" do |value|
        instance_variable_set var_name, value
      end

      define_singleton_method name do
        if instance_variable_defined? var_name
          instance_variable_get var_name
        else
          instance_variable_set var_name, block.call(self)
        end
      end
    end

    def attributes= attrs
      attrs.each do |k,v|
        public_send "#{k}=", v
      end
    end
  end
end