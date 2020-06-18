require "test_helper"

describe ProductsController do
  before do
    @leash = products(:leash)
    perform_login(users(:grace))
  end

  describe "index" do
    it "responds to success for all products" do
      get products_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "will get show for valid product id" do
      valid_product_id = @leash.id

      get product_path(valid_product_id)

      must_respond_with :success
    end
  end

  it "will redirect for invalid product id" do
    get product_path(-1)

    must_respond_with :redirect

    must_redirect_to root_path
  end

  describe "new" do
    it "can get the new product path" do
      get new_product_path

      must_respond_with :success
    end
  end

  describe "create" do

    let (:new_puppy_toy) {
      {
        product: {
          name: "toy toy testing",
          price: 4.99,
          description: "a fun toy for your dog",
          stock: 2,
          photo_url: "https://dogtime.com/assets/uploads/2011/03/puppy-development-1280x720.jpg",
          user_id: 3,
          product_status: "active"
        },
      }
    }
    it "can create a new product with valid information" do
      
      expect { post products_path, params: new_puppy_toy }.must_differ "Product.count", 1
      must_respond_with :redirect
      expect(Product.last.name).must_equal new_puppy_toy[:product][:name]
      expect(Product.last.price).must_equal new_puppy_toy[:product][:price]
      expect(Product.last.description).must_equal new_puppy_toy[:product][:description]
      expect(Product.last.photo_url).must_equal new_puppy_toy[:product][:photo_url]
      expect(Product.last.user_id).must_equal session[:user_id]
      expect(Product.last.product_status).must_equal new_puppy_toy[:product][:product_status]

    end

    it "cannot create a new product with invalid information" do
      new_puppy_toy[:product][:name] = nil
      expect { post products_path, params: new_puppy_toy }.wont_change "Product.count"
    end

    it "cannot create a new product if not logged in" do
     
      # needs 'user not logged in' indicated here
      expect { post products_path, params: new_puppy_toy }.wont_change "Product.count"
      expect(flash[:error]).must_equal "You must be logged in to create a new product."

    end

    describe "update" do
      let (:new_puppy_toy) {
        {
          product: {
            name: "yummy toy",
            price: 2.99,
            description: "a fun toy for your dog",
            stock: 10,
            photo_url: "https://dogtime.com/assets/uploads/2011/03/puppy-development-1280x720.jpg",
            user_id: session[:user_id]
          },
        }
      }
      it "will update products and count will not change" do
        new_puppy_toy[:product][:name] = "testing toy"
        id = Product.first.id

        expect { patch product_path(id), params: new_puppy_toy }.wont_change "Product.count"
        must_redirect_to products_path

        product = Product.find_by(id: id)

        expect(product.name).must_equal new_puppy_toy[:product][:name]
        expect(product.price).must_equal new_puppy_toy[:product][:price]
        expect(product.stock).must_equal new_puppy_toy[:product][:stock]
        expect(product.description).must_equal new_puppy_toy[:product][:description]
        expect(product.photo_url).must_equal new_puppy_toy[:product][:photo_url]
        expect(product.user_id).must_equal session[:user_id]
      end
      it "will respond with flash error message for updating invalid product id" do
        expect { patch product_path(-1), params: new_puppy_toy }.wont_change "Product.count"
        expect(flash[:error]).to be_present
      end
      it "will not update if the params are invalid" do
        new_puppy_toy[:product][:name] = nil
        product = Product.first
        expect { patch product_path(product.id), params: new_puppy_toy }.wont_change "Product.count"
        product.reload
        expect(product.name).wont_be_nil
      end

    end
    describe "change_product_status" do
   
      it "can have a product status of active" do
        expect(@leash.product_status).must_equal "active"
        must_redirect_to root_path

      end
      
      it "can have a product status of inactive" do
        @leash.product_status = "inactive"
        expect(@leash.product_status).must_equal "inactive"
        must_redirect_to root_path

      end

      # it "can only be changed by merchant who owns the product" do 
        
      # end
    end
  end
end
