require "mongoid/document"
require "mongoid/relatives"

class Product
  include Mongoid::Document
  include Mongoid::Relatives

  field :name, type: String

  relates_many :orders,  class_path: 'Order.items'
end
