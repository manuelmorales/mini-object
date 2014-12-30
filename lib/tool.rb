module MiniObject
  class Tool
    include Injectable

    attr_accessor :name

    def initialize name = nil, &block
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

    alias define define_singleton_method

    private

    def get_subject
      @subject ||= build_subject
    end

    def set_subject block
      @subject_block = block
    end

    def build_subject
      if @subject_block
        instance_eval &@subject_block
      else
        raise NotImplementedError.new("Undefined subject for #{self.inspect}")
      end
    end
  end
end
