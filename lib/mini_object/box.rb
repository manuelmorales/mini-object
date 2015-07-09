module MiniObject
  class Box
    include Injectable
    include RemarkableInspect
    include MiniObject

    def initialize attrs = {}
      self.attributes= attrs
    end
  end
end
