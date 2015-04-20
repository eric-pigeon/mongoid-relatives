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

            # this function is doing WAY too much work need to
            # clean this up
            def criteria(metadata, object, type = nil)

              path_info = relation_path_info(metadata)

              initial = {key: [metadata.foreign_key], selector: object}

              path_info.drop(1).reverse_each do |info|

                if info[:macro] == :embeds_one
                  initial = embeds_one_criteria(initial, relation_info)
                else
                  initial = embeds_many_criteria(initial, info)
                  initial[:selector] = initial[:selector].selector
                end
              end

              if path_info.first[:macro] == :embeds_one
                initial = embeds_one_criteria(initial, path_info.first)
                metadata.klass.where(initial[:key].join(".") => initial[:selector])
              else
                embeds_many_criteria(initial, path_info.first)[:selector]
              end
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

            private

            def relation_path_info(metadata)
              current_klass = metadata.klass

              metadata.class_path.map do |relation_name|
                meta          = current_klass.relations[relation_name]
                klass         = current_klass
                current_klass = meta.klass

                raise Mongoid::Relatives::Errors::InvalidRelationPath.new(
                  metadata.inverse_class_name,
                  metadata.name,
                  meta.inverse_class_name,
                  relation_name
                ) unless meta.relation.embedded?

                { macro: meta.macro, klass: klass, relation: relation_name}
              end
            end

            def embeds_many_criteria(partial, relation_info)
              match_obj = partial[:key].empty??
                partial[:selector] :
                { partial[:key].join(".") => partial[:selector] }

              return {
                selector: relation_info[:klass].elem_match(relation_info[:relation] => match_obj),
                key: []
              }
            end

            def embeds_one_criteria(partial, relation_info)
              partial[:key] = partial[:key].unshift(relation_info[:relation])
              return partial
            end

          end
        end
      end
    end
  end
end
