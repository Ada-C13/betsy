# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_18_200329) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_products", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_categories_products_on_category_id"
    t.index ["product_id"], name: "index_categories_products_on_product_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "uid"
    t.string "provider"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_merchants_on_order_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.bigint "order_id"
    t.string "photo_url", default: "https://f1.pngfuel.com/png/584/952/34/black-and-white-flower-black-white-m-leaf-plant-stem-silhouette-computer-line-plants-png-clip-art.png"
    t.string "fulfillment_status", default: "pending"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "card_number"
    t.string "card_expiration_date"
    t.string "card_cvv"
    t.string "address"
    t.string "city"
    t.string "zip_code"
    t.string "guest_name"
    t.string "email"
    t.string "phone_num"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "cart_status", default: true
    t.bigint "merchant_id"
    t.string "state"
    t.index ["merchant_id"], name: "index_orders_on_merchant_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "description"
    t.integer "inventory"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "merchant_id"
    t.boolean "status"
    t.string "photo_url"
    t.index ["merchant_id"], name: "index_products_on_merchant_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.integer "rating"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "merchants"
  add_foreign_key "products", "merchants"
  add_foreign_key "reviews", "products"
end
