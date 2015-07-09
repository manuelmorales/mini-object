module MiniObject
  class Resolver < Delegator
    def initialize &block
      @block = block
    end

    def __getobj__
      @block.call
    end

    def resolver_bound
      @block.binding.eval('self')
    end
  end
end
