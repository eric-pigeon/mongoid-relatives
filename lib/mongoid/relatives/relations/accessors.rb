module Mongoid
  module Relatives
    module Relations
      module Accessors
        extend ActiveSupport::Concern

        def __build__(name, object, metadata)
          relation = create_relation(object, metadata)
          set_relation(name, relation)
        end

        def create_relation(object, metadata)
          type = @attributes[metadata.inverse_type]
          target = metadata.builder(self, object).build(type)
          target ? metadata.relation.new(self, target, metadata) : nil
        end

        def set_relation(name, relation)
          instance_variable_set("@_#{name}", relation)
        end

        private

        def get_relation(name, metadata, object, reload = false)
          if !reload && (value = ivar(name)) != false
            value
          else
            _building do
              _loading do
                if object && needs_no_database_query?(object, metadata)
                  __build__(name, object, metadata)
                else
                  __build__(name, attributes[metadata.key], metadata)
                end
              end
            end
          end
        end

        module ClassMethods
          def getter(name, metadata)
            define_method(name) do |reload = false|
              value = get_relation(name, metadata, nil, reload)
              if value.nil? && metadata.autobuilding? && !without_autobuild?
                value = send("build_#{name}")
              end
              value
            end
            self
          end
        end
      end
    end
  end
end
