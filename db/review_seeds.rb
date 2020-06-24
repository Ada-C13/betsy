require 'csv'
require 'faker'
require 'date'

# ruby db/review_seeds.rb

CSV.open("db/seeds/review_seeds.csv", "w", :write_headers => true, :headers => ["rating","description","reviewer","product_id", "created_at"]) do |row|
  100.times do 
    rating = rand(3..5)
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = rand(1..100)
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today) 

    row << [rating, description, reviewer, product_id, created_at]
  end

  # dog nose
  25.times do 
    rating = 5
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = 663
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today)
    row << [rating, description, reviewer, product_id, created_at]
  end


  # cat nose
  20.times do 
    rating = 5
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = 382
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today)
    row << [rating, description, reviewer, product_id, created_at]
  end

  # helmet
  11.times do 
    rating = 5
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = 2666
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today)
    row << [rating, description, reviewer, product_id, created_at]
  end

  # plant
  13.times do 
    rating = 5
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = 51
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today)
    row << [rating, description, reviewer, product_id, created_at]
  end

  25.times do 
    rating = rand(3..5)
    description = Faker::Quote.famous_last_words
    reviewer = Faker::Name.name
    product_id = 80
    created_at = Faker::Time.between(from: Date.today - 120, to: Date.today)
    row << [rating, description, reviewer, product_id, created_at]
  end
end 
