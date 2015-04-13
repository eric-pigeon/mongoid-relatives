require "spec_helper"

describe Mongoid::Relatives do

  before(:each) do
    @shirt = Product.create!(name:"t-shirt")

    @order1 = Order.create!(
      items:[Order::Item.new(product:@shirt)]
    )

    @order2 = Order.create!(
      items:[Order::Item.new(product:@shirt)]
    )

    @split_order = SplitOrder.new(shipments:[
      SplitOrder::Shipment.new(items:[
        product: @shirt
      ])
    ])
    @split_order.save!

    @split_order2 = SplitOrder.new(shipments:[
      SplitOrder::Shipment.new(items:[
        product: @shirt
      ])
    ])
    @split_order2.save!
  end

  it "should define relation" do
    expect(@shirt.relations).to have_key "orders"
  end

  it "should define method" do
    expect(@shirt.methods).to include :orders
  end

  it "should return the correct inverse" do
    expect(SplitOrder::Shipment::Item.relations["product"].inverse).to eq(:split_orders)
    expect(Product.relations["orders"].inverse).to eq(:product)
    expect(Order::Item.relations["product"].inverse).to eq(:orders)
  end

  it "should return same object" do
    expect(@shirt.orders.first.id).to eq(@order1.id)
    expect(@shirt.orders[1].id).to eq(@order2.id)
  end

  it "should have the right count" do
    expect(@shirt.orders.count).to eq(2)
    expect(@shirt.split_orders.count).to eq(2)
  end

  it "should work with doubly nested documents" do
    expect(@shirt.split_orders.first.id).to eq(@split_order.id)
    expect(@shirt.split_orders[1].id).to eq(@split_order2.id)
  end

  context "when trying to define class path with referential class path" do
    class Band
      include Mongoid::Document
      include Mongoid::Relatives

      has_many :albums
    end

    class Album
      include Mongoid::Document
      include Mongoid::Relatives

      belongs_to :band
      associates_to :studio
    end

    class Studio
      include Mongoid::Document
      include Mongoid::Relatives

      relates_many :albums, class_path: "Band.albums"
    end

    let(:band) do
      Band.new
    end

    let(:studio) do
      Studio.new
    end

    let(:alubm) do
      Album.new(band:band,studio:studio)
    end

    it "raises invalid path error" do
      expect{studio.albums}.to raise_error(Mongoid::Relatives::Errors::InvalidRelationPath)
    end

  end

end
