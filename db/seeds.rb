# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

# SEEDING CATEGORIES
counter1 = 1 
CATEGORY_FILE = Rails.root.join('db', 'categories_seeds.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = counter1
  counter1 += 1
  category.name = row['name']
  successful = category.save
  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}, #{category.errors.messages}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"


# SEEDING MERCHANTS
counter4 = 1 
MERCHANT_FILE = Rails.root.join('db', 'merchants_seeds.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = counter4
  counter4 += 1
  merchant.name = row['name']
  merchant.uid = row['uid']
  merchant.email = row['email']
  merchant.provider = row['provider']
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}, #{merchant.errors.messages}"
  else
    puts "Created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"


# SEEDING PRODUCTS
counter2 = 1
PRODUCT_FILE = Rails.root.join('db','products_seeds.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = counter2
  counter2 += 1
  product.name = row['name']
  product.price = row['price']
  product.stock = row['stock']
  product.active = row['active']
  product.description = row['description']
  product.photo = row['photo']
  merchant = Merchant.all.shuffle.first
  product.merchant_id = merchant.id
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}, #{product.errors.messages}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"


# SEEDING JOING TABLE CATEGORIES_PRODUCTS
# we created a loop that is runing the size of product.all.length 
# and it's assigning in the same time two categories for a product in random way.
(Product.all.length).times do |time|
  product = Product.find_by(id: (time + 1))
  category1 = Category.all.shuffle.first
  category2 = Category.all.shuffle.last
  product.categories << category1
  product.categories << category2
  if product.categories.size == 2
    c = product.categories
    puts "Product #{time + 1} categories: #{
      c.each do |c|
        c.id
      end
    }"
  else
    puts "You couldn't save the data in join table!!"
  end
end

# SEEDING REVIEWS
counter3 = 1
REVIEWS_FILE = Rails.root.join('db', 'reviews_seeds.csv')
puts "Loading raw review data from #{REVIEWS_FILE}"

review_failures = []
CSV.foreach(REVIEWS_FILE, :headers => true) do |row|
  review = Review.new
  review.id = counter3
  counter3 += 1
  review.rating = row['rating']
  review.feedback = row['feedback']
  product = Product.all.shuffle.first
  review.product_id = product.id
  successful = review.save
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}, #{review.errors.messages}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"