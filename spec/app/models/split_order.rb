require "mongoid/document"

class SplitOrder
  include Mongoid::Document

  embeds_many :shipments, class_name: "SplitOrder::Shipment"

  class Shipment
    include Mongoid::Document
    embedded_in :order,  class_name: "SplitOrder"
    embeds_many :items,  class_name: "SplitOrder::Shipment::Item"

    class Item
      include Mongoid::Document
      include Mongoid::Relatives

      embedded_in   :shipment, class_name: "SplitOrder::Shipment"
      associates_to :product,  class_name: "Product"
    end
  end
end
