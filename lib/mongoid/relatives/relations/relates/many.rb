require "mongoid/relations/targets"
require "mongoid/relatives/errors/invalid_relation_path"

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
              path = metadata.class_path.split(".")
              current_klass = metadata.klass
              path_info = []

              path.each do |relation_name|
                meta = current_klass.relations[relation_name]
                raise Mongoid::Relatives::Errors::InvalidRelationPath.new(
                  metadata.inverse_class_name,
                  metadata.name,
                  meta.inverse_class_name,
                  relation_name
                ) unless meta.relation.embedded?
                path_info << { macro: meta.macro, klass: current_klass, relation: relation_name}
                current_klass = meta.klass
              end
              selector = path_info.drop(1).reverse_each.inject({metadata.foreign_key => object}) do |sel, info|
                info[:klass].elem_match(info[:relation] => sel).selector
              end

              metadata.klass.elem_match(path.first => selector)
            end

            def embedded?
              false
            end

            def foreign_key_suffix
              "_id"
            end

            def foreign_key(name)
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
