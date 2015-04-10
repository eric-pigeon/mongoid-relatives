require "spec_helper"

describe Mongoid::Relatives::Relations::Relates::In do

  describe ".embedded?" do

    it "returns false" do
      expect(described_class).to_not be_embedded
    end
  end

  describe ".foreign_key_suffix" do

    it "returns _id" do
      expect(described_class.foreign_key_suffix).to eq("_id")
    end
  end

  describe ".macro" do

    it "returns belongs_to" do
      expect(described_class.macro).to eq(:associates_to)
    end
  end

  describe ".stores_foreign_key?" do

    it "returns true" do
      expect(described_class.stores_foreign_key?).to be true
    end
  end

  describe ".valid_options" do

    it "returns the valid options" do
      expect(described_class.valid_options).to eq([])
    end
  end

end
