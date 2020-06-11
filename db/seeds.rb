# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

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
    puts "Failed to save category: #{category.inspect}"
  else
    puts "Created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"



PRODUCT_FILE = Rails.root.join('db','products_seeds.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

counter2 = 1

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
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} product failed to save"



REVIEWS_FILE = Rails.root.join('db', 'reviews_seeds.csv')
puts "Loading raw review data from #{REVIEWS_FILE}"

counter3 = 1

review_failures = []
CSV.foreach(REVIEWS_FILE, :headers => true) do |row|
  review = Reveiw.new
  review.id = counter3
  counter3 += 1
  review.rating = row['rating']
  review.feedback = row['feedback']
  successful = review.save
  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Reveiw.count} review records"
puts "#{review_failures.length} reviews failed to save"