class Order
  include Mongoid::Document

  embeds_many :items, class_name: "Order::Item"

  class Item
    include Mongoid::Document
    include Mongoid::Relatives

    embedded_in   :order,   class_name: "Order"
    associates_to :product, class_name: "Product"
  end
end
