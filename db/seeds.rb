require 'csv'
require 'faker'

USER_FILE = Rails.root.join('db','seeds','villagers_seeds.csv')

puts "Loading raw product data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, :headers => true) do |row|
  user = User.new
  user.name = row['name']
  user.username = row['full_id']
  user.email_address = Faker::Internet.email
  user.photo_url = row['photo_url']
  user.species = row['species']
  user.personality = row['personality']
  user.phrase = row['phrase']
  user.uid = row['row_n']
  successful = user.save

  if !successful
    user_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} user failed to save"


# =====
# category
# =====

CATEGORY_FILE = Rails.root.join('db', 'seeds', 'category_seeds.csv')
puts "Loading raw vote data from #{CATEGORY_FILE}"

category_failures = []
CSV.foreach(CATEGORY_FILE, :headers => true) do |row|
  category = Category.new
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


# =====
# product
# =====
PRODUCT_FILE = Rails.root.join('db', 'seeds', 'item_seeds.csv')
users = User.all

puts "Loading raw product data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, :headers => true) do |row|
  if row['id_full'] != "NA" && row['image_url'] != "NA" && row['sell_value'] && row['sell_value'].to_i >= 0
    product = Product.new
    product.name = row['name']
    product.description = row['id_full']
    product.price = row['sell_value'].to_i
    product.inventory = rand(5..10)
    product.photo_url = row['image_url']
    product.active = true
    product.user_id = rand(1...users.length)

    # categories_products (join table)
    category = Category.find_by(name: row['category'])

    if !category 
      category = Category.create(name: row['category'])
    end

    product.categories << category 
    successful = product.save
  end

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"



products = Product.all

users.each do |user|
  5.times do 
    random_idx = rand(0...products.length)
    user.products << products[random_idx]
  end
end


# =====
# review
# =====

REVIEW_FILE = Rails.root.join('db', 'seeds', 'review_seeds.csv')
puts "Loading raw vote data from #{REVIEW_FILE}"

review_failures = []

CSV.foreach(REVIEW_FILE, :headers => true) do |row|
  review = Review.new
  review.rating = row['rating']
  review.reviewer = row['reviewer']
  review.description = row['description'].gsub(/"/, "")
  review.product_id = row['product_id']
  review.created_at = row['created_at']
  
  successful = review.save

  if !successful
    review_failures << review
    puts "Failed to save review: #{review.inspect}"
  else
    puts "Created review: #{review.inspect}"
  end
end

puts "Added #{Review.count} review records"
puts "#{review_failures.length} reviews failed to save"


# Since we set the primary key (the ID) manually on each of the
# tables, we've got to tell postgres to reload the latest ID
# values. Otherwise when we create a new record it will try
# to start at ID 1, which will be a conflict.
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"


# faker - reference: https://stackoverflow.com/questions/23121016/using-faker-gem-to-generate-date