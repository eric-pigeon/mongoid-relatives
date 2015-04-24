require "mongoid/relations"

module Mongoid
  module Relatives
    module Relations
      module Builders
        module Relates
          class In < Mongoid::Relations::Builder
            def build(type = nil)
              return object unless query?
              model = type ? type.constanttize : metadata.klass
              metadata.criteria(object, model).first
            end
          end
        end
      end
    end
  end
end
