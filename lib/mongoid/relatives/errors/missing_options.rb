module Mongoid
  module Relatives
    module Errors
      class MissingOptions < StandardError
        def initialize(name, invalid)
          #TODO make useful message
          super("\n" + name + invalid)
        end
      end
    end
  end
end
