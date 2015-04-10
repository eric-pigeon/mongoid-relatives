require "spec_helper"

describe Mongoid::Relatives::Relations::Macros do

  class TestClass
    include Mongoid::Document
    include Mongoid::Relatives
  end

  let(:klass) do
    TestClass
  end

  describe ".associates_to" do

    it "defines the macro" do
      expect(klass).to respond_to(:associates_to)
    end

    context "when defining the relation" do

      before do
        klass.associates_to(:person)
      end

      it "adds the metadata to the klass" do
        expect(klass.relations["person"]).to_not be_nil
      end

      it "defines the getter" do
        expect(klass.allocate).to respond_to(:person)
      end

      it "defines the setter" do
        expect(klass.allocate).to respond_to(:person=)
      end

      #it "defines the builder" do
      #  expect(klass.allocate).to respond_to(:build_person)
      #end

      #it "defines the creator" do
      #  expect(klass.allocate).to respond_to(:create_person)
      #end

      it "creates the correct relation" do
        expect(klass.relations["person"].relation).to eq(
          Mongoid::Relatives::Relations::Relates::In
        )
      end

      it "creates the field for the foreign key" do
        expect(klass.allocate).to respond_to(:person_id)
      end

      context "metadata properties" do

        let(:metadata) do
          klass.relations["person"]
        end

        it "automatically adds the name" do
          expect(metadata.name).to eq(:person)
        end

        it "automatically adds the inverse class name" do
          expect(metadata.inverse_class_name).to eq("TestClass")
        end
      end
    end

  end

  describe ".relates_many" do

    it "defines the macro" do
      expect(klass).to respond_to(:relates_many)
    end

    context "when a class_path isn't provided" do

      it "raises an InvalidOptions" do
        expect{
          klass.relates_many(:products)
        }.to raise_error(Mongoid::Relatives::Errors::MissingOptions)
      end

    end

    context "when defining the relation" do

      before do
        klass.relates_many(:products, class_path:"test")
      end

      it "adds the metadata to the klass" do
        expect(klass.relations["products"]).to_not be_nil
      end

      it "defines the getter" do
        expect(klass.allocate).to respond_to(:products)
      end

      #it "defines the setter" do
      #  expect(klass.allocate).to respond_to(:posts=)
      #end

      it "creates the correct relation" do
        expect(klass.relations["products"].relation).to eq(
          Mongoid::Relatives::Relations::Relates::Many
        )
      end

      #it "adds an associated validation" do
      #  expect(klass._validators[:posts].first).to be_a(
      #    Mongoid::Validatable::AssociatedValidator
      #  )
      #end

      context "metadata properties" do

        let(:metadata) do
          klass.relations["products"]
        end

        it "automatically adds the name" do
          expect(metadata.name).to eq(:products)
        end

        it "automatically adds the inverse class name" do
          expect(metadata.inverse_class_name).to eq("TestClass")
        end
      end
    end

    #context 'when defining order on relation' do

    #  before do
    #    klass.has_many(:posts, order: :rating.asc)
    #  end

    #  let(:metadata) do
    #    klass.relations["posts"]
    #  end

    #  it "adds metadata to klass" do
    #    expect(metadata.order).to_not be_nil
    #  end

    #  it "returns Origin::Key" do
    #    expect(metadata.order).to be_kind_of(Origin::Key)
    #  end
    #end

    #context "when setting validate to false" do

    #  before do
    #    klass.has_many(:posts, validate: false)
    #  end

    #  it "does not add associated validations" do
    #    expect(klass._validators).to be_empty
    #  end
    #end

  end

end
