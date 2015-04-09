require 'spec_helper'

describe Mongoid::Relatives::Relations::Metadata do

  describe "#related_klass" do

    context "when class_path is nil" do
      let(:metadata) do
        described_class.new(
          inverse_class_name: "Order",
          relation: Mongoid::Relations::Embedded::In
        )
      end

      it "returns the inverse_klass" do
        expect(metadata.related_klass).to eq(metadata.inverse_klass)
      end
    end

    context "when class_path is not nil" do
      let(:metadata) do
        described_class.new(
          class_name: "Order",
          class_path: "items",
          relation: Mongoid::Relatives::Relations::Relates::Many
        )
      end

      it "returns the nested related class" do
        expect(metadata.related_klass).to eq(Order::Item)
      end
    end

  end

end
