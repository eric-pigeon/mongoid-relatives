require "spec_helper"

describe Mongoid::Relatives do

  let(:shirt) { Product.create!(name:"shirt") }

  let!(:order1) { Order.create!(items:[Order::Item.new(product:shirt)]) }

  let!(:order2) { Order.create!(items:[Order::Item.new(product:shirt)]) }

  let!(:split_order1) do
    SplitOrder.create!(shipments:[
      SplitOrder::Shipment.new(items:[
        product: shirt
      ])
    ])
  end

  let!(:split_order2) do
    SplitOrder.create!(shipments:[
      SplitOrder::Shipment.new(items:[
        product: shirt
      ])
    ])
  end

  it "should return the correct inverse" do
    expect(SplitOrder::Shipment::Item.relations["product"].inverse).to eq(:split_orders)
    expect(Product.relations["orders"].inverse).to eq(:product)
    expect(Order::Item.relations["product"].inverse).to eq(:orders)
  end

  it "should return same object" do
    expect(shirt.orders[0].id).to eq(order1.id)
    expect(shirt.orders[1].id).to eq(order2.id)
  end

  it "should have the right count" do
    expect(shirt.orders.count).to eq(2)
    expect(shirt.split_orders.count).to eq(2)
  end

  it "should work with doubly nested documents" do
    expect(shirt.split_orders[0].id).to eq(split_order1.id)
    expect(shirt.split_orders[1].id).to eq(split_order2.id)
  end

  context "when only using embeds_one" do
    class Person
      include Mongoid::Document

      embeds_one :house
    end

    class House
      include Mongoid::Document
      include Mongoid::Relatives

      embedded_in :person
      associates_to :state
    end

    class State
      include Mongoid::Document
      include Mongoid::Relatives

      relates_many :people, class_path: "Person.house"
    end

    let!(:state)  { State.create!() }
    let!(:person1) { Person.create!(house:House.new(state:state)) }
    let!(:person2) { Person.create!(house:House.new(state:state)) }

    it "should return the same object" do
      expect(state.people[0].id).to eq(person1.id)
      expect(state.people[1].id).to eq(person2.id)
    end

  end

  context "when using single embeds_many" do
  end

  context "when using embeds_one into embeds_many" do
  end

  context "when using embeds_many into embeds_one" do
  end

  context "when using embeds_many into embends_many" do
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

    let(:studio) do
      Studio.new
    end

    it "raises invalid path error" do
      expect{studio.albums}.to raise_error(Mongoid::Relatives::Errors::InvalidRelationPath)
    end

  end

end
