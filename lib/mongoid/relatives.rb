require "mongoid/relatives/version"
require "active_support"
require "active_support/core_ext"
require "mongoid/relatives/relations/relates/many"
require "mongoid/relatives/relations/builders/relates/many"
require "mongoid/relatives/relations/accessors"
require "mongoid/relatives/relations/macros"
require "mongoid/relatives/relations/metadata"

module Mongoid
  module Relatives
    extend ActiveSupport::Concern
    include Relations::Accessors
    include Relations::Macros
  end
end
