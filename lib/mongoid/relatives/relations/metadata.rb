require "mongoid/relations"

module Mongoid
  module Relatives
    module Relations
      class Metadata < Mongoid::Relations::Metadata

        def class_path
          self[:class_path]
        end

        def related_klass
          #TODO will need to be recursive i think
          klass.relations[class_path].class_name.constantize
        end

        def determine_inverse_relation
          default = foreign_key_match || related_klass.relations[inverse_klass.name.underscore]
          return default.name if default
          names = inverse_relation_candidate_names
          if names.size > 1
            raise Errors::AmbiguousRelationship.new(klass, inverse_klass, name, names)
          end
          names.first
        end

        def inspect
%Q{#<Mongoid::Relatives::Relations::Metadata
  autobuild:    #{autobuilding?}
  class_name:   #{class_name}
  class_path:   #{class_path}
  cyclic:       #{cyclic.inspect}
  counter_cache:#{counter_cached?}
  dependent:    #{dependent.inspect}
  inverse_of:   #{inverse_of.inspect}
  key:          #{key}
  macro:        #{macro}
  name:         #{name}
  order:        #{order.inspect}
  polymorphic:  #{polymorphic?}
  relation:     #{relation}
  setter:       #{setter}>
}
        end
      end
    end
  end
end
