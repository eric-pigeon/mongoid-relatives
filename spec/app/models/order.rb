require "mongoid/document"

class Order
  include Mongoid::Document

  embeds_many :items, class_name: "Order::Item"

  class Item
    include Mongoid::Document

    embedded_in :order,   class_name: "Order"
    belongs_to  :product, class_name: "Product"
  end
end
