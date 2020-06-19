# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



require 'csv'

categories = [
  {
    name: "Abstract"
  },
  {
    name: "Realism"
  },  
  {
    name: "Surrealism"
  },  
  {
    name: "Pop Art"
  },  
  {
    name: "Sculpture"
  },  
]

count = 0
categories.each do |category|
  if Category.create(category)
    count += 1
  end
end


MERCHANT_FILE = Rails.root.join('db','merchant-seeds.csv',)
merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true ) do |row|
  merchant = Merchant.new
  merchant.username = row['username']
  merchant.email = row['email']

  successful = merchant.save

  if !successful
    merchant_failures << merchant 
    puts "Failed to save merchant: #{merchant.inspect}"
  else   
    puts "Created merchant: #{merchant.inspect}"
  end 
end 

PRODUCT_FILE = Rails.root.join('db','products-seeds3.csv',)
product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true ) do |row|
  categories_sample = []
  categories_sample.push(rand(1..5))
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.artist = row['artist']
  product.merchant_id = row['merchant_id']

  product.category_ids = categories_sample

  product.active = row['active']
  product.image = row['image']

  successful = product.save

  if !successful
    product_failures << product 
    puts "Failed to save product: #{product.inspect}"
  else   
    puts "Created product: #{product.inspect}"
  end 
  
end 

REVIEW_FILE = Rails.root.join('db','review-seeds.csv',)
review_failures = []
CSV.foreach(REVIEW_FILE, :headers => true ) do |row|
  review = Review.new
  review.rating = row['rating']
  review.description = row['description']
  review.product_id = row['product_id']

  successful = review.save

  if !successful
    review_failures << review 
    puts "Failed to save review: #{review.inspect}"
  else   
    puts "Created review: #{review.inspect}"
  end 
  
end 

puts "Created #{count} categories"

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"
