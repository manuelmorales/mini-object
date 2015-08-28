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
      if value == NULL && block == nil
        get_attribute name
      else
        set_attribute name, value, block
      end
      end
    end

    def self.setter_definition_for name
      lambda do |value|
        set_attribute name, value
      end
    end

    def cattr_injectable name, &block
      define_singleton_method name, &Injectable.getsetter_definition_for(name)
      define_singleton_method "#{name}=", &Injectable.setter_definition_for(name)
      define_method name, -> { self.class.name }
      send(name, &block) if block
    end

    def attr_injectable name, &block
      define_method name, &Injectable.getsetter_definition_for(name)
      define_method "#{name}=", &Injectable.setter_definition_for(name)
      instance_variable_set("@#{name}_default_proc", block) if block
    end

    def attributes= attrs
      attrs.each do |k,v|
        public_send "#{k}=", v
      end
    end

    private

    def get_attribute name
      if eval "defined? @#{name}"
        # Get via variable
        instance_variable_get :"@#{name}"
      elsif eval "defined? @#{name}_proc"
        # Get via proc
        instance_variable_get(:"@#{name}_proc").call
      else
        # Get default
        self.class.send(:name)
      end
    end

    def set_attribute name, value = NULL, block = nil
      if value == NULL
        # Set via proc
        instance_variable_set :"@#{name}_proc", block
        remove_instance_variable :"@#{name}" if eval "defined? @#{name}"
      elsif value == nil && block
        # Set via proc
        instance_variable_set :"@#{name}_proc", block
        remove_instance_variable :"@#{name}" if eval "defined? @#{name}"
      else
        # Set via variable
        instance_variable_set :"@#{name}", value
        remove_instance_variable :"@#{name}_proc" if eval "defined? @#{name}_proc"
      end

      block || value
    end
  end
end
