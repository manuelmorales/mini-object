require 'delegate'

module MiniObject
  class Lazy < Delegator
    attr_accessor :lazy_name

    def initialize name = nil, &block
      self.lazy_name = name
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

    def build &block
      @block = block
    end

    def inspect
      prefix = lazy_name ? "#{lazy_name}: " : ""
      steps = " " + build_steps.keys.join(", ") if build_steps.any?
      "< #{prefix}Lazy(#{formatted_block_source}#{steps}) >"
    end

    alias to_s inspect

    private

    def build_steps
      @build_steps ||= {}
    end

    def block_source
      require 'method_source'
      begin
        MethodSource.source_helper(@block.source_location)
      rescue MethodSource::SourceNotFoundError
        '{???}'
      end
    end

    def formatted_block_source
      code = block_source.split("\n").map(&:strip).join("; ")
      code = code[0..59] + "\u2026" if code.length > 60
      code.inspect
    end
  end
end
