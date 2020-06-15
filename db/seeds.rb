require 'csv'

# Merchant seeds
MERCHANT_FILE = Rails.root.join('db', 'seed_data', 'merchants.csv')
puts "Loading raw merchant data from #{MERCHANT_FILE}"

merchant_failures = []
CSV.foreach(MERCHANT_FILE, :headers => true) do |row|
  merchant = Merchant.new
  merchant.id = row['id']
  merchant.email = row['email']
  merchant.username = row['username']
  merchant.uid = row['uid']
  merchant.provider = row['provider']
  
  successful = merchant.save
  if !successful
    merchant_failures << merchant
    p merchant.errors
  end
end

puts "Added #{Merchant.count} merchant records"
puts "#{merchant_failures.length} merchants failed to save"

# Category seeds
CATEGORY_FILE = Rails.root.join('db', 'seed_data', 'categories.csv')
puts "Loading raw category data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
  category.id = row['id']
  category.name = row['name']
  category.description = row['description']

  successful = category.save
  if !successful
    category_failures << category
  end
end

puts "Added #{Category.count} category records"
puts "#{category_failures.length} categories failed to save"

# Product seeds
PRODUCT_FILE = Rails.root.join('db', 'seed_data', 'products.csv')
puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  product = Product.new
  product.id = row['id']
  product.name = row['name']
  product.description = row['description']
  product.photo = row['photo']
  product.stock = row['stock']
  product.active = row['active']
  product.price = row['price']
  product.merchant_id = row['merchant_id']
  if !row['category_ids'].nil? 
    row['category_ids'].each_char do |id|
      product.categories << Category.find(id)
    end
  end

  successful = product.save
  if !successful
    product_failures << product
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

# Order seeds
ORDER_FILE = Rails.root.join('db', 'seed_data', 'orders.csv')
puts "Loading raw order data from #{ORDER_FILE}"

order_failures = []
CSV.foreach(ORDER_FILE, :headers => true) do |row|
  order = Order.new
  order.id = row['id']
  order.status = row['status']
  order.credit_card_num = row['credit_card_num']
  order.credit_card_exp = row['credit_card_exp']
  order.credit_card_cvv = row['credit_card_cvv']
  order.address = row['address']
  order.city = row['city']
  order.state = row['state']
  order.zip = row['zip']
  order.time_submitted = row['time_submitted']
  order.customer_email = row['customer_email']

  successful = order.save
  if !successful
    order_failures << order
  end
end

puts "Added #{Order.count} order records"
puts "#{order_failures.length} orders failed to save"

# OrderItem seeds
ORDER_ITEM_FILE = Rails.root.join('db', 'seed_data', 'order_items.csv')
puts "Loading raw order_item data from #{ORDER_ITEM_FILE}"

order_item_failures = []
CSV.foreach(ORDER_ITEM_FILE, :headers => true) do |row|
  order_item = OrderItem.new
  order_item.id = row['id']
  order_item.quantity = row['quantity']
  order_item.order_id = row['order_id']
  order_item.product_id = row['product_id']

  successful = order_item.save
  if !successful
    order_item_failures << order_item
  end
end

puts "Added #{OrderItem.count} order item records"
puts "#{order_item_failures.length} order items failed to save"

# reloading postgres for the latest ID
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"