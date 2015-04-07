class Product
  include Mongoid::Document
  include Mongoid::Relatives

  field :name, type: String

  relates_many :orders,  class_path: 'Order.items'
  relates_many :split_orders, class_path: 'SplitOrder.shipments.items'
end
