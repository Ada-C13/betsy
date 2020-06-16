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
      # merchants(:merchantaaa) from the fixture file owns 3 products
      target_products = Product.all.find_all { |p|
        p.merchant == @merchant
      }
      p target_products
      expect(@merchant.products.length).must_equal target_products.length
      @merchant.products.each do |product|
        expect(target_products).must_include product
        target_products.delete(product)
        expect(product).must_be_instance_of Product
      end
    end


    it 'has many order_item' do
      # merchants(:merchantaaa) from the fixture file has 3 order items
      expect(@merchant.order_items.count).must_equal 3
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

  describe "calculate_revenue" do
    let(:new_merchant) {merchants(:merchantddd)}
    let(:merchant) {merchants(:merchantaaa)} 
    let(:new_product) { 
      Product.new(
        name: "XXXX", 
        price: 20.00,
        stock: 20,
        description: "XXX XXX XXXX XXX XXXXXXXXXX XXXXXXXX XXXXXXXX XXXXXXX XXXXX XXXX XXXXX",
        photo: "https://i.imgur.com/WSHmeuf.jpg",
        merchant: nil
      )
    }
    it "returns 0 when there's no merchant products" do
      expect(new_merchant.calculate_revenue).must_equal 0
    end
    it "returns 0 when there's no order items" do
      new_product.merchant = new_merchant
      expect(new_merchant.calculate_revenue).must_equal 0
    end
    it "returns 0 when there's no order items that are paid or shipped" do
      new_product.merchant = new_merchant
      item = OrderItem.new(quantity: 1)
      item.product = new_product
      expect(new_merchant.calculate_revenue).must_equal 0
    end
    it "returns expected revenue" do
      order_items = OrderItem.all.find_all { |item|
        item.product.merchant == merchant &&
        item.status != "pending"
      }
      revenue = order_items.sum { |item|
        item.quantity * item.product.price
      }
      expect(merchant.calculate_revenue).must_equal revenue
    end
  end
end
