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

ActiveRecord::Schema.define(version: 20160114065451) do

  create_table "adverts", force: :cascade do |t|
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "adverts", ["category_id"], name: "index_adverts_on_category_id"

  create_table "attributes", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "string_attributes", force: :cascade do |t|
    t.integer  "max_length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "values", force: :cascade do |t|
    t.integer  "advert_id"
    t.integer  "attribute_category_id"
    t.string   "type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "values", ["advert_id"], name: "index_values_on_advert_id"
  add_index "values", ["attribute_category_id"], name: "index_values_on_attribute_category_id"

end
