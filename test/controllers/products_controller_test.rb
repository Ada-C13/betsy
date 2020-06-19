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
    
    let (:no_url) {
        {
          product: {
            name: "yummy toy",
            price: 2.99,
            description: "a fun toy for your dog",
            stock: 10,
            photo_url: "",
            user_id: session[:user_id]
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

    it "will set default photo url for valid product" do
      expect { post products_path, params: no_url }.must_differ "Product.count", 1
      must_respond_with :redirect
    
      expect(Product.last.photo_url).must_equal "https://lh3.googleusercontent.com/0hJSje8_Z034MV_zDnQFGVt1Id-P21tDb3AP-J7WFtH0ITgL47YvUV642kZg1fXxtZaO47A14pRjWP2tG-2AlHm7jst2i8mB-yZQPX0I67SB4X9iJs4Co9lge5RlgsMoK8BeP1pXNtKuQkneNuBrxPr-x6n2KpVj7tA_E4k1krdZPj6Z_kZT8XzNIN_ztY3rD9HdwInpgaQ7HYImlTdGo_A50RoLEJ-7sK2_gFJAbSLIwnxEAAcaw7ELKxhO0p2QUbBk8Qwp3GnleViM2LVIUIQMcQDt7JvcKgPWH1DpNYpv8GRitVPOIBOt4mVvsVSJ5I6iBXU_7Tz1b1HQC97OajROBAWNSYryi_wqrac6MjfwFS0VbRxiAthPtUxApWpwTmxSF8LTqtUh2MQfLnOGp4wnX-CkfIQzqazG20xxXvsv24iLE1PZwjwkFb2vE8fglhUr0PAvEHseJz7D1PJwt5MtH38gdDPTK8o8WhJ1R4vGaiCqcekvR6OUGy4DYUEjW-zd3psZpwuQLxPLlgefvSvL4lErgVrxV8bg61cn7WcQ2Avev4L36DAS40RyY0cqInt_CJ-9Ovp3oRPTwTp0EwEL2XmHHKoW8yaSgJloyjAzWT9SHAAnoAoTjHWeHvXot8qdWvT8dwmq-LRsR_-cpE5-qNo2ejrkDUrCD5k7R35r5F_TKXLG9CX-Tkrf7g=w600-h512-no?authuser=0"
    end

    it "cannot create a new product with invalid information" do
      new_puppy_toy[:product][:name] = nil
      expect { post products_path, params: new_puppy_toy }.wont_change "Product.count"
    end

    it "cannot create a new product if not logged in" do
      delete logout_path
      
      expect { post products_path, params: new_puppy_toy }.wont_change "Product.count"
      expect(flash[:error]).must_equal "You must be logged in to create a new product."
      must_redirect_to root_path

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

      it "will not update product with invalid product id and will redirect" do
        expect { patch product_path(-1), params: new_puppy_toy }.wont_change "Product.count"
        must_redirect_to root_path
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

      it "will change the product status from active to inactive" do
        patch change_product_status_path(@leash) 
        reloaded_leash = Product.find_by(id: @leash.id)
        expect(reloaded_leash.product_status).must_equal "inactive"
        must_redirect_to myaccount_path

      end

      it "will change the product status from inactive to active" do
        @collar = products(:collar)
        patch change_product_status_path(@collar) 
        reloaded_collar = Product.find_by(id: @collar.id)
        expect(reloaded_collar.product_status).must_equal "active"
        must_redirect_to myaccount_path

      end
    end
  end
end 


