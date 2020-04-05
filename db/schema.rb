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

ActiveRecord::Schema.define(version: 2020_04_04_203408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balance_trackings", force: :cascade do |t|
    t.string "total"
    t.integer "portafolio_id"
    t.string "date_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "crypto_assets", force: :cascade do |t|
    t.string "cryptoId"
    t.string "name"
    t.string "rank"
    t.string "symbol"
    t.string "supply"
    t.string "maxSupply"
    t.string "marketCapUsd"
    t.string "volumeUsd24Hr"
    t.string "priceUsd"
    t.string "changePercent24Hr"
    t.float "crypto_Percentage"
    t.integer "portafolio_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "portafolios", force: :cascade do |t|
    t.string "name"
    t.integer "user_id"
    t.float "balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
