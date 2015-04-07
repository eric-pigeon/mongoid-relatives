module Mongoid
  module Relatives
    module Relations
      extend ActiveSupport::Concern

      attr_accessor :__metadata
      alias :relation_metadata :__metadata

      def referenced_many?
        __metadata && (__metadata.macro == :has_many || __metadata.macro == :relates_many)
      end
    end
  end
end
