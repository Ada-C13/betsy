# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# MERCHANTS

MERCHANTS_FILE = Rails.root.join('db', 'merchant-seed.csv')
puts "Loading raw merchant data from #{MERCHANTS_FILE}"

merchant_failures = []
CSV.foreach(MERCHANTS_FILE, :headers => true) do |row|
  merchant = Merchant.new 
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = rand(1..100)
  merchant.provider = "github"
  
  successful = merchant.save

  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchants"
puts "#{merchant_failures.length} merchants failed to save"

# CATEGORIES

CATEGORIES_FILE = Rails.root.join('db', 'category-seed.csv')
puts "Loading raw category data from #{CATEGORIES_FILE}"

category_failures = []
CSV.foreach(CATEGORIES_FILE, :headers => true) do |row|
  category = Category.new 
  category.name = row['name']
  
  successful = category.save

  if !successful
    category_failures << category
    puts "Failed to save category: #{category.inspect}"
  else
    puts "created category: #{category.inspect}"
  end
end

puts "Added #{Category.count} categories"
puts "#{category_failures.length} categories failed to save"

# PRODUCTS

PRODUCTS_FILE = Rails.root.join('db', 'product-seed.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new 
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['inventory']
  product.description = row['description']
  product.status = row['status']
  product.photo_url = row['photo_url']
  product.merchant_id = Merchant.find(rand(1..3)).id
  successful = product.save

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} products"
puts "#{product_failures.length} products failed to save"


# CATEGORIES_PRODUCTS

CATEGORIES_PRODUCTS_FILE = Rails.root.join('db', 'category-product-seed.csv')
puts "Loading raw category data from #{CATEGORIES_PRODUCTS_FILE}"

categoryproduct_failures = []
CSV.foreach(CATEGORIES_PRODUCTS_FILE, :headers => true) do |row|
  category = Category.find_by(id: row["category_id"]) 
  product = Product.find_by(id: row["product_id"]) 
  product.categories << category
  
  successful = product.save

  if !successful
    categoryproduct_failures << product
    puts "Failed to add category #{category.inspect} to product #{product.inspect}"
  else
    puts "added category #{category.inspect} to product #{product.inspect}"
  end
end

# puts "Added #{Category_Product.count} category-product relationships"
puts "#{categoryproduct_failures.length} category-product relationships failed to save"

# ORDERS

ORDERS_FILE = Rails.root.join('db', 'orders-seed.csv')
puts "Loading raw orders data from #{ORDERS_FILE}"

order_failures = []
CSV.foreach(ORDERS_FILE, :headers => true) do |row|
  order = Order.new 
  order.card_number = row['card_number']
  order.card_expiration_date = row['card_expiration_date']
  order.card_cvv = row['card_cvv']
  order.address = row['address']
  order.city = row['city']
  order.zip_code = row['zip_code']
  order.guest_name = row['guest_name']
  order.email = row['email']
  order.phone_num = row['phone_num']
  order.cart_status = row['cart_status']
  
  successful = order.save

  if !successful
    order_failures << order
    puts "Failed to save order: #{order.inspect}"
  else
    puts "created order: #{order.inspect}"
  end
end

puts "Added #{Order.count} orders"
puts "#{order_failures.length} orders failed to save"

#ORDER ITEMS

ORDER_ITEMS_FILE = Rails.root.join('db', 'order-items-seed.csv')
puts "Loading raw order items data from #{ORDER_ITEMS_FILE}"

order_item_failures = []
CSV.foreach(ORDER_ITEMS_FILE, :headers => true) do |row|
  order_item = OrderItem.new 
  order_item.name = row['name']
  order_item.price = row['price']
  order_item.quantity = row['quantity']
  order_item.product_id = row['product_id']
  order_item.order_id = row['order_id']
  order_item.fulfillment_status = row['fulfillment_status']
  
  successful = order_item.save

  if !successful
    order_item_failures << order_item
    puts "Failed to save order item: #{order_item.inspect}"
  else
    puts "created order item: #{order_item.inspect}"
  end
end

puts "Added #{OrderItem.count} order items"
puts "#{order_item_failures.length} order items failed to save"


puts "Manually resetting each table's PK sequence"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "Done!"

