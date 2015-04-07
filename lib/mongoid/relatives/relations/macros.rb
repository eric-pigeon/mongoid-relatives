require "mongoid/relations/macros"

module Mongoid
  module Relatives
    module Relations
      module Macros
        extend Mongoid::Relations::Macros

        module ClassMethods
          def relates_many(name, options = {})
            # TODO raise exception
            path = options[:class_path].split(".")
            class_name = path.shift()
            options.merge!({
              class_name: class_name,
              class_path: path.join(".")
            })
            meta = characterize(name, Relates::Many, options)
            relate_getter(name, meta)
            meta
          end

          def associates_to(name, options = {})
            meta = characterize(name, Relates::In, options)
            relate(name, meta)
            reference(meta)
            aliased_fields[name.to_s] = meta.foreign_key
            touchable(meta)
            meta
          end

          private

          def characterize(name, relation, options)
            Mongoid::Relatives::Relations::Metadata.new({
              relation: relation,
              inverse_class_name: self.name,
              name: name
            }).merge(options)
          end

          def relate_getter(name, metadata)
            self.relations = relations.merge(name.to_s => metadata)
            getter(name, metadata)
          end
        end
      end
    end
  end
end
