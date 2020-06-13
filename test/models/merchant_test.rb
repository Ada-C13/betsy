require "test_helper"

describe Merchant do
  before do
    @merchant = merchants(:merchantaaa) 
  end

  let (:new_merchant) {
    Merchant.new(
      name: "Kobe",
      email: "kobe@ada.org",
      provider: "github",
      uid: "670123",
      )
  }

  it "merchant can be instantiated" do
    expect(new_merchant.valid?).must_equal true
  end

  it "merchant will have the required field" do
    new_merchant.save
    new_merchant = Merchant.find_by(uid: "670123")
    [:name, :uid].each do |field|
      expect(new_merchant).must_respond_to field
    end
  end

  describe 'relations' do
    it 'has many products' do
      # merchants(:merchantaaa) from the fixture file owns 2 products
      expect(@merchant.products.count).must_equal 2
      @merchant.products.each do |product|
        expect(product).must_be_instance_of Product
      end
    end


    it 'has many order_item' do
      # merchants(:merchantaaa) from the fixture file has 2 order items
      expect(@merchant.order_items.count).must_equal 2
      @merchant.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end
  end

  describe "validations" do
    it "merchant must have a name" do
      # Arrange
      @merchant.name = nil
      # Assert
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :name
      expect(@merchant.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "it's valid when merchant has name" do
      @merchant.name = "Manny"
      expect(@merchant.valid?).must_equal true
    end

    it "merchant must have a uid number" do
      # Arrange
      @merchant.uid = nil
      # Assert
      expect(@merchant.valid?).must_equal false
      expect(@merchant.errors.messages).must_include :uid
      expect(@merchant.errors.messages[:uid]).must_equal ["can't be blank"]
    end

    it "it's valid when merchant has uid" do
      @merchant.uid = "938475"
      expect(@merchant.valid?).must_equal true
    end
  end
end
