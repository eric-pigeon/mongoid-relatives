require "mongoid/relations/macros"
require "mongoid/relatives/errors/missing_options"

MissingOptions = Mongoid::Relatives::Errors::MissingOptions

module Mongoid
  module Relatives
    module Relations
      module Macros
        extend Mongoid::Relations::Macros

        module ClassMethods
          def relates_many(name, options = {})
            raise MissingOptions.new(
              name.to_s,
              "class_path"
            ) if options[:class_path].nil?

            path = options[:class_path].split(".")
            options.merge!({
              class_name: path.shift(),
              class_path: path
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
            }.merge(options))
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
