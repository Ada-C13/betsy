require "csv"
products_file = Rails.root.join("db", "products.csv")
categories_file = Rails.root.join("db", "categories.csv")
merchants_file = Rails.root.join("db", "merchants.csv")
catetory_product_file = Rails.root.join("db", "category-product-assignments.csv")

# create merchants from csv
CSV.foreach(merchants_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Merchant.create!(data)
end

# create products from csv
CSV.foreach(products_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Product.create!(data)
end

# create categories from csv
CSV.foreach(categories_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Category.create!(data)
end

# Add categories to products

# puts "BEFORE FIRST: #{Product.first.categories.count}"
# puts "BEFORE LAST: #{Product.last.categories.count}"

CSV.foreach(catetory_product_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  product_id = row[0]
  category_id = row[1]

  selected_product = Product.find_by(id: product_id)
  selected_category = Category.find_by(id: category_id)
  
  selected_product.categories << selected_category
end

# puts "FIRST: #{Product.first.categories.count}"
# puts "LAST: #{Product.last.categories.count}"