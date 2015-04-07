module Mongoid
  module Relatives
    module Relations
      module Bindings
        module Relates
          class In < Mongoid::Relations::Binding
            def bind_one
              binding do
                check_inverses!(target)
                bind_foreign_key(base, record_id(target))
                bind_polymorphic_inverse_type(base, target.class.name)
                #since this can be called before embedded documents
                #parents are set don't try to set associates_to
                #documents
                #if inverse = metadata.inverse(target)
                #  if set_base_metadata
                #    if base.referenced_many?
                #      p "TARGET"
                #      p target
                #      p "INVERSE"
                #      p inverse
                #      p "BASE"
                #      p base
                #      p metadata
                #      target.__send__(inverse).push(base)
                #    else
                #      target.set_relation(inverse, base)
                #    end
                #  end
                #end
              end
            end
          end
        end
      end
    end
  end
end
