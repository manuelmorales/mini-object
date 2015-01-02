module MiniObject
  class Tool
    include Injectable

    attr_accessor :name
    attr_accessor :parent

    def initialize name = nil, attrs = {}, &block
      attrs.each do |k,v|
        send "#{k}=", v
      end

      @name = name
      @subject_block = block
    end

    def get
      subject
    end

    def subject &block
      if block
        set_subject block
      else
        get_subject
      end
    end

    def define name, &block
      dsl.define_singleton_method name, &block
    end

    def ancestors
      parent ? (parent.ancestors + [parent]) : []
    end

    def root
      ancestors.first
    end

    private

    def get_subject
      @subject ||= build_subject
    end

    def set_subject block
      @subject_block = block
    end

    def build_subject
      if @subject_block
        dsl.evaluate &@subject_block
      else
        raise NotImplementedError.new("Undefined subject for #{self.inspect}")
      end
    end

    def dsl
      @dsl ||= ForwardingDSL.new(self, :define)
    end
  end
end
