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

ActiveRecord::Schema.define(version: 20200829080210) do

  create_table "active_admin_comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "namespace"
    t.text     "body",          limit: 65535
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "carts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "offer_id"
    t.integer  "user_id"
    t.string   "mode_of_payment"
    t.string   "status"
    t.string   "addres_line_1"
    t.string   "addres_line_2"
    t.string   "city"
    t.string   "postal_code"
    t.string   "state"
    t.string   "delivery_place"
    t.string   "mobile_number"
    t.datetime "unconfirmed_at"
    t.datetime "pending_at"
    t.datetime "approved_at"
    t.datetime "confirmed_at"
    t.datetime "cancelled_at"
    t.datetime "delivered_at"
    t.string   "delivery_person_name"
    t.string   "delivery_person_mobile_number"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["offer_id"], name: "index_carts_on_offer_id", using: :btree
    t.index ["user_id"], name: "index_carts_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.string   "photo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "description"
    t.string   "title"
    t.decimal  "value",       precision: 11, scale: 8
    t.decimal  "max_value",   precision: 11, scale: 8
    t.string   "kind"
    t.string   "code"
    t.datetime "starts_at"
    t.datetime "finishes_at"
    t.boolean  "active",                               default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_orders_on_cart_id", using: :btree
    t.index ["product_id"], name: "index_orders_on_product_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "sub_category_id"
    t.string   "name"
    t.integer  "quantity"
    t.decimal  "price",           precision: 11, scale: 8
    t.decimal  "discount",        precision: 11, scale: 8
    t.boolean  "availability",                             default: true
    t.datetime "deleted_at"
    t.string   "photo_url"
    t.string   "unit"
    t.string   "discount_kind"
    t.decimal  "tax_rate",        precision: 11, scale: 8
    t.string   "description"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["sub_category_id"], name: "index_products_on_sub_category_id", using: :btree
  end

  create_table "sub_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_sub_categories_on_category_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.decimal  "latitude",               precision: 11, scale: 8
    t.decimal  "longitude",              precision: 11, scale: 8
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "country"
    t.string   "photo_url"
    t.string   "mobile_number"
    t.datetime "date_of_birth"
    t.string   "new_email"
    t.string   "new_mobile_number"
    t.string   "whatsapp_mobile_number"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_foreign_key "carts", "offers"
  add_foreign_key "carts", "users"
  add_foreign_key "orders", "carts"
  add_foreign_key "orders", "products"
  add_foreign_key "products", "sub_categories"
  add_foreign_key "sub_categories", "categories"
end
