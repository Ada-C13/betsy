require "test_helper"

describe Product do
  let(:product4) { 
    Product.new(
      name: "Card Board",
      price: 3.99,
      img_url: "https://live.staticflickr.com/65535/49991751098_c017304fc3y_m.jpg",
      description: "Make a sign",
      qty: 50,
      merchant: merchants(:merchant1)
    )
  }

  describe "relations" do 
    let(:product) { products(:product1) }
    
    describe "review relations" do
      it "can have many reviews" do
        expect(product).must_respond_to :reviews
        expect(product.reviews.length).must_equal 3
      end
      
      it "can have zero reviews" do
        product2 = products(:product2)
        expect(product2.reviews.length).must_equal 0
      end
    end
  
    describe "category relations" do
      it "can access the categories related to the product throug join table" do        
        expect(product).must_respond_to :categories
        expect(product.categories.count).must_equal 2
        product.categories.each do |categ|
          expect(categ).must_be_instance_of Category
        end
      end
  
      it "can have zero categories" do
        expect(products(:product3).categories.count).must_equal 0
      end
    end

    describe "order_items relations" do
      it "can have many order items" do
        expect(product).must_respond_to :order_items
        expect(product.order_items.length).must_equal 2
      end
      
      it "can have zero order items" do
        product4.save
        expect(product4.order_items.length).must_equal 0
      end
    end
    
    describe "order relations" do
      it "has many orders thrugh order_items" do
        expect(product).must_respond_to :order_items
        expect(product.order_items.length).must_equal 2
      end
    end

    describe "merchant relations" do
      it "has one merchant" do
        expect(product).must_respond_to :merchant
        expect(product.merchant).must_be_instance_of Merchant
      end
    end

  end
  
  describe "validations" do
    it "is valid for a product with all required fields" do
      expect(product4.valid?).must_equal true
    end 

    it "has the required fields" do
      product4.save
      new_product = Product.last
    
      [:name, :price, :img_url, :qty, :description].each do |field|
        expect(new_product).must_respond_to field
      end
    end

    it "is invalid without a name" do
      product4.name = nil
      
      expect(product4.valid?).must_equal false
      expect(product4.errors.messages).must_include :name
    end

    it "cannot creat a new product with the same name" do
      product4.save
      product5 = Product.new(
        name: "Card Board",
        price: 3.99,
        img_url: "https://live.staticflickr.com/65535/49991751098_c017304fc3y_m.jpg",
        description: "Make a sign",
        qty: 50,
        merchant: merchants(:merchant1)
      )
      expect(product5.valid?).must_equal false
      expect(product5.errors.messages).must_include :name
    end

    it "is invalid without a price" do
      product4.price = nil
      
      expect(product4.valid?).must_equal false
      expect(product4.errors.messages).must_include :price
    end

    it "cannot creat a new order_item with a negative or zero price" do
      product4.price = 0
      
      expect(product4.valid?).must_equal false
      expect(product4.errors.messages).must_include :price
    end

    it "is invalid without a qty" do
      product4.qty = nil
      
      expect(product4.valid?).must_equal false
      expect(product4.errors.messages).must_include :qty
    end

    it "cannot creat a new order_item with a non integer qty" do
      product4.qty = 50.50
      
      expect(product4.valid?).must_equal false
      expect(product4.errors.messages).must_include :qty
    end

  end

  describe "average rating" do
    
    describe "average rating" do
      it "can calculate the average rating for a product with many ratings" do
        expect(products(:product1).average_rating).must_equal 3.67
      end

      it "average rating of a product with no review is zero" do
        expect(products(:product2).average_rating).must_equal 0
      end
    end

  end

  describe "available?" do 
    it "return true if product has available stock" do # inspired by "can't add a product without enough stock
      product1 = products(:product1)
      available_qty = Product.available?(product1.id, 1)
      expect(available_qty).must_equal true
    end

    it "return false if product does not have available stock" do # inspired by "can't add a product wihtout enough stock
      product1 = products(:product1)
      available_qty = Product.available?(product1.id, 11)
      expect(available_qty).must_equal  false
    end
  end


  describe "update_quantity" do 
    it "correctly subtracts quantity" do 
      product1 = products(:product1)
      Product.update_quantity(product1.id, 2)
      product1.reload
      expect(product1.qty).must_equal  8
    end

    it "correctly subtracts all available items" do 
      product1 = products(:product1)
      Product.update_quantity(product1.id, 10)
      product1.reload
      expect(product1.qty).must_equal  0
    end

   
  end
end
