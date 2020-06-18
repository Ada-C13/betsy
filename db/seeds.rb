# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
require "csv"
media_file = Rails.root.join("db", "products.csv")
merchants = Rails.root.join("db", "merchants.csv")

CSV.foreach(merchants, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Merchant.create!(data)
end
puts "Created #{Merchant.count} merchants"


CSV.foreach(media_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Product.create!(data)
end
puts "Created #{Product.count} products"

  
categories = [
  {
    title: "Wand"
  },
  {
    title: "Plant"
  },
  {
    title: "Book"
  }
]

count = 0
categories.each do |category|
  if Category.create(category)
    count += 1
  end
end
puts "Created #{count} categories"

26.times do |i|
  next if i == 0 || i == 3
  Product.find(i).categories << Category.where(title: "Plant")
end
Category.find(3) << Category.where(title: "Book")
(27..44).each do |i|
  Product.find(i).categories << Category.where(title: "Wand")
end

(45..70).each do |i|
  Product.find(i).categories << Category.where(title: "Book")
end