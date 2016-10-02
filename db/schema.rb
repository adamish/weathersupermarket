# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130917062548) do

  create_table "forecasts", force: true do |t|
    t.datetime "date"
    t.string   "daytime"
    t.string   "summary"
    t.string   "symbol"
    t.integer  "temp_min"
    t.integer  "temp_max"
    t.integer  "wind_speed"
    t.string   "wind_dir"
    t.string   "link"
    t.integer  "stars"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forecasts", ["date"], name: "index_forecasts_on_date"
  add_index "forecasts", ["location_id"], name: "index_forecasts_on_location_id"

  create_table "locations", force: true do |t|
    t.integer  "provider_id"
    t.datetime "last_fetch"
    t.string   "name"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["provider_id", "token"], name: "index_locations_on_provider_id_and_token", unique: true

  create_table "metoffice_locations", force: true do |t|
    t.string   "name"
    t.string   "name_lower"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metoffice_locations", ["name_lower"], name: "index_metoffice_locations_on_name_lower"

  create_table "providers", force: true do |t|
    t.string "name"
  end

  create_table "quicklink_locations", force: true do |t|
    t.integer  "location_id"
    t.integer  "quicklink_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quicklinks", force: true do |t|
    t.string   "quicklink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quicklinks", ["quicklink"], name: "index_quicklinks_on_quicklink", unique: true

  create_table "search_results", force: true do |t|
    t.integer  "location_id"
    t.integer  "search_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.string   "search"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
