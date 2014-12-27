module MiniObject
  class Lazy < Delegator
    attr_accessor :name

    def initialize opts = {}, &block
      opts.each do |k,v|
        send "#{k}=", v
      end

      self.name ||= 'anon'

      @block = block
    end

    def __getobj__
      @obj ||= @block.call.tap do |obj|
        build_steps.each do |name, block|
          block.call obj
        end
      end
    end

    alias get_obj __getobj__

    def resolver_bound
      @block.binding.eval('self')
    end

    def build_step name, &block
      build_steps[name] = block
    end

    def inspect
      "< #{name}: Lazy(#{formatted_block_source} #{build_steps.keys.join(", ")}) >"
    end

    private

    def build_steps
      @build_steps ||= {}
    end

    def block_source
      require 'method_source'
      MethodSource.source_helper(@block.source_location)
    end

    def formatted_block_source
      code = block_source.split("\n").map(&:strip).join("; ")
      code = code[0..59] + "\u2026" if code.length > 60
      code.inspect
    end
  end
end
