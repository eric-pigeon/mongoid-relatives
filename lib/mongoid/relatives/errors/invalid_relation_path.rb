module Mongoid
  module Relatives
    module Errors
      class InvalidRelationPath < Mongoid::Errors::MongoidError

        def initialize(model, relation, invalid_model, invalid_relation)
          super(
            compose_message(
              "invalid_relation_path",
              {
                model: model,
                relation: relation,
                invalid_model: invalid_model,
                invalid_relation: invalid_relation
              }
            )
          )
        end

      end
    end
  end
end
