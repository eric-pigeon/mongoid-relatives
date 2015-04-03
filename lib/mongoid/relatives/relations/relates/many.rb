require "mongoid/relations/targets"

module Mongoid
  module Relatives
    module Relations
      module Relates
        class Many < Mongoid::Relations::Proxy

          delegate :count, to: :criteria
          delegate :first, :in_memory, :last, :reset, :uniq, to: :target

          def initialize(base, target, metadata)
            init(base, Mongoid::Relations::Targets::Enumerable.new(target), metadata) do
              raise_mixed if klass.embedded? && !klass.cyclic?
            end
          end

          private

          def criteria()
            Many.criteria(
              __metadata,
              Mongoid::Relations::Conversions.flag(base.send(__metadata.primary_key), __metadata),
              base.class
            )
          end

          class << self
            def builder(base, meta, object)
              Builders::Relates::Many.new(base, meta, object || [])
            end

            def criteria(metadata, object, type = nil)
              metadata.klass.elem_match(metadata.class_path => {metadata.foreign_key => object})
            end

            def embedded?
              false
            end

            def foreign_key_suffix
              "_id"
            end

            def foreign_key
              "#{name}#{foreign_key_suffix}"
            end

            def stores_foreign_key?
              false
            end

            def macro
              :relates_many
            end

            def valid_options
              [:class_path]
            end
          end
        end
      end
    end
  end
end
