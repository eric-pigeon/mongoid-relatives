require "mongoid/relations"

module Mongoid
  module Relations
    class Metadata
      def class_path
        self[:class_path]
      end
    end
  end

  module Relatives
    module Relations
      class Metadata < Mongoid::Relations::Metadata

        def related_klass
          return inverse_klass if class_path.nil?
          path = class_path.split(".")
          last = klass
          path.each do |relation_name|
            last = last.relations[relation_name].klass
          end
          last
        end

        def inverse_relation_candidates
          if class_path
            related_klass.relations.values.select do |meta|
              next if meta.name == name
              (meta.class_name == inverse_class_name) && !meta.forced_nil_inverse?
            end
          else
            relations_metadata.select do |meta|
              next if meta.name == name
              if meta.class_path
                (meta.related_klass == inverse_klass) && !meta.forced_nil_inverse?
              else
                (meta.class_name == inverse_class_name) && !meta.forced_nil_inverse?
              end
            end
          end
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
