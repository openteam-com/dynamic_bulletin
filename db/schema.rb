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

ActiveRecord::Schema.define(version: 20160313073221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adverts", force: :cascade do |t|
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  add_index "adverts", ["category_id"], name: "index_adverts_on_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "ancestry"
    t.integer  "ancestry_depth", default: 0
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree

  create_table "category_properties", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_public", default: true
    t.boolean  "necessarily",    default: false
    t.string   "show_as",        default: "check_boxes"
  end

  create_table "hierarch_list_items", force: :cascade do |t|
    t.string   "title"
    t.string   "ancestry"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "hierarch_list_items", ["property_id"], name: "index_hierarch_list_items_on_property_id", using: :btree

  create_table "list_item_values", force: :cascade do |t|
    t.integer "list_item_id"
    t.integer "value_id"
    t.integer "hierarch_list_item_id"
  end

  create_table "list_items", force: :cascade do |t|
    t.string   "title"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "ancestry"
  end

  add_index "list_items", ["ancestry"], name: "index_list_items_on_ancestry", using: :btree
  add_index "list_items", ["property_id"], name: "index_list_items_on_property_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string  "role"
    t.integer "user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "kind"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "row_order"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "values", force: :cascade do |t|
    t.integer  "advert_id"
    t.integer  "property_id"
    t.string   "string_value"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "list_item_id"
    t.integer  "integer_value"
    t.integer  "hierarch_list_item_id"
  end

  add_index "values", ["advert_id"], name: "index_values_on_advert_id", using: :btree
  add_index "values", ["list_item_id"], name: "index_values_on_list_item_id", using: :btree
  add_index "values", ["property_id"], name: "index_values_on_property_id", using: :btree

  add_foreign_key "adverts", "categories"
  add_foreign_key "hierarch_list_items", "properties"
  add_foreign_key "list_items", "properties"
  add_foreign_key "values", "adverts"
  add_foreign_key "values", "properties"
end
