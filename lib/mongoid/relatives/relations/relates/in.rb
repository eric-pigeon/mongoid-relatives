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

            def criteria(metadata, object, type = nil)
              return type.where(metadata.primary_key => object) if metadata.class_path.nil?

              path_info = relation_path_info(metadata)
              initial = {key: [metadata.primary_key], selector: object}

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

              {
                selector: relation_info[:klass].elem_match(relation_info[:relation] => match_obj),
                key: []
              }
            end

            def embeds_one_criteria(partial, relation_info)
              partial[:key] = partial[:key].unshift(relation_info[:relation])
              partial
            end
          end
        end
      end
    end
  end
end
