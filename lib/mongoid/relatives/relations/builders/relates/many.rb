require "mongoid/relations"

module Mongoid
  module Relatives
    module Relations
      module Builders
        module Relates
          class Many < Mongoid::Relations::Builder
            def build(type = nil)
              return object unless query?
              return [] if object.is_a?(Array)
              metadata.criteria(Mongoid::Relations::Conversions.flag(object, metadata), base.class)
            end
          end
        end
      end
    end
  end
end
