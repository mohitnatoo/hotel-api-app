# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_06_23_223228) do

  create_table "hotel_room_prices", force: :cascade do |t|
    t.integer "hotel_room_id"
    t.date "date", null: false
    t.float "price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_hotel_room_prices_on_date"
    t.index ["hotel_room_id", "date"], name: "index_hotel_room_prices_on_hotel_room_id_and_date"
    t.index ["hotel_room_id"], name: "index_hotel_room_prices_on_hotel_room_id"
  end

  create_table "hotel_rooms", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "room_type_id"
    t.float "default_price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id", "room_type_id"], name: "index_hotel_rooms_on_hotel_id_and_room_type_id", unique: true
    t.index ["hotel_id"], name: "index_hotel_rooms_on_hotel_id"
    t.index ["room_type_id"], name: "index_hotel_rooms_on_room_type_id"
    t.index [nil], name: "index_hotel_rooms_on_hotel"
    t.index [nil], name: "index_hotel_rooms_on_room_type"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.integer "reservation_id"
    t.string "source", default: "stripe", null: false
    t.string "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_payment_transactions_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_date"], name: "index_reservations_on_end_date"
    t.index ["room_id"], name: "index_reservations_on_room_id"
    t.index ["start_date"], name: "index_reservations_on_start_date"
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index [nil], name: "index_reservations_on_user"
  end

  create_table "room_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "occupancy_limit", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "occupancy_limit"], name: "index_room_types_on_name_and_occupancy_limit", unique: true
    t.index ["occupancy_limit"], name: "index_room_types_on_occupancy_limit"
  end

  create_table "rooms", force: :cascade do |t|
    t.integer "hotel_room_id"
    t.string "room_number", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_room_id"], name: "index_rooms_on_hotel_room_id"
    t.index [nil], name: "index_rooms_on_hotel_room"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
