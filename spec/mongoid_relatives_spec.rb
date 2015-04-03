require "spec_helper"

describe Mongoid::Relatives do

  before(:each) do
    @shirt = Product.create!(name:"t-shirt")

    @order1 = Order.create!()
    Order::Item.create!(order:@order1,product:@shirt)

    @order2 = Order.create!()
    Order::Item.create!(order:@order2,product:@shirt)

  end

  it "should define relation" do
    expect(@shirt.relations).to have_key "orders"
  end

  it "should define method" do
    expect(@shirt.methods).to include :orders
  end

  it "should return same object" do
    expect(@shirt.orders.first.id).to eq(@order1.id)
  end

  it "should have the right count" do
    expect(@shirt.orders.count).to eq(2)
  end

  #it "should define fields" do
  #  expect(@shirt.fields).to have_key "orders"
  #end

end
