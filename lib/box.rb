module MiniObject
  class Box
    include Injectable
    include RemarkableInspect

    def initialize attrs = {}
      self.attributes= attrs
    end
  end
end
