require "test_helper"

describe User do
  describe "initialize" do
    before do
      @new_user = User.new(name: "camden", email_address: "camden@ajonisle.com", uid: 666)
    end

    it "can be instantiated" do
      expect(@new_user.valid?).must_equal true
    end
    
    it "has required fields" do
      [:name, :email_address, :uid].each do |field|
        expect(@new_user).must_respond_to field
      end
    end
  end

  describe "validations" do
    before do
      @user = User.create(name: "camden", email_address: "camden@ajonisle.com", uid: 666)
    end

    describe "name" do
      it "must have a name" do
        @user.name = nil

        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :name
        expect(@user.errors.messages[:name]).must_equal ["can't be blank"]
      end

      it "must have a unique name" do
        same_user = User.create(name: "camden", email_address: "camden@ajonisle.com", uid: 666)
        
        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :name
        expect(same_user.errors.messages[:name]).must_equal ["has already been taken"]
      end
    end

    describe "email_address" do
      it "must have an email_address" do
        @user.email_address = nil

        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :email_address
        expect(@user.errors.messages[:email_address]).must_equal ["can't be blank"]
      end

      it "must have a unique email_address" do
        same_user = User.new(name: "camden", email_address: "camden@ajonisle.com", uid: 666)

        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :email_address
        expect(same_user.errors.messages[:email_address]).must_equal ["has already been taken"]
      end
    end

    describe "uid" do
      it "must have an uid" do
        @user.uid = nil

        expect(@user.valid?).must_equal false
        expect(@user.errors.messages).must_include :uid
        expect(@user.errors.messages[:uid]).must_equal ["can't be blank"]
      end

      it "must have a unique uid" do
        same_user = User.create(name: "camden", email_address: "camden@ajonisle.com", uid: 666)

        expect(same_user.valid?).must_equal false
        expect(same_user.errors.messages).must_include :uid
        expect(same_user.errors.messages[:uid]).must_equal ["has already been taken"]
      end
    end
  end

  describe "relationships" do
    before do
      @user = User.new(name: "camden", email_address: "camden@ajonisle.com", uid: 666)
    end

    it "can be created without a product" do
      expect(@user.save).must_equal true
    end

    it "can have a product" do
      @user.save

      product = Product.create(user: @user, name: "sloth nose", description: "how about a c+", price: 400, inventory: 9, photo_url: "https://villagerdb.com/images/items/thumb/sea-bass-model.7217621.png", active: true)  # a name must be unique
    
      expect(@user.products.last).must_be_instance_of Product
      expect(@user.products.last.name).must_equal product.name
    end
  end

  describe "build from github" do
    it "buils auth_hash from github" do
      auth_hash = {
        "uid" => 12345,
        "info" => {
          "name" => "Annalise",
          "nickname" => "Anna",
          "email" => "annalise@ajonisle.com"
        }
      }

      new_user = User.build_from_github(auth_hash)

      expect(new_user).must_be_kind_of User
      expect(new_user.uid).must_equal auth_hash[:uid]
      expect(new_user.username).must_equal auth_hash["info"]["name"]
      expect(new_user.name).must_equal auth_hash["info"]["nickname"]
      expect(new_user.email_address).must_equal auth_hash["info"]["email"]
    end
  end
end
