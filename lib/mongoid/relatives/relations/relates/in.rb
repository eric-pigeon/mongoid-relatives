module Mongoid
  module Relatives
    module Relations
      module Relates
        class In < Mongoid::Relations::Proxy

          def initialize(base, target, metadata)
            init(base, target, metadata) do
              characterize_one(target)
              bind_one
            end
          end

          private

          def binding
            Bindings::Relates::In.new(base, target, __metadata)
          end

          class << self
            def builder(base, meta,object)
              Builders::Relates::In.new(base, meta, object)
            end

            def embedded?
              false
            end

            def foreign_key(name)
              "#{name}#{foreign_key_suffix}"
            end

            def foreign_key_default
              nil
            end

            def foreign_key_suffix
              "_id"
            end

            def stores_foreign_key?
              true
            end

            def macro
              :associates_to
            end

            def valid_options
              []
            end
          end
        end
      end
    end
  end
end
