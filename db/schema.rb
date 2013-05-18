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

ActiveRecord::Schema.define(version: 20130518012320) do

  create_table "amazon_stocks", force: true do |t|
    t.string   "asin",                             null: false
    t.string   "url",                              null: false
    t.string   "medium_image_url",    default: "", null: false
    t.integer  "medium_image_width",  default: 0,  null: false
    t.integer  "medium_image_height", default: 0,  null: false
    t.string   "small_image_url",     default: "", null: false
    t.integer  "small_image_width",   default: 0,  null: false
    t.integer  "small_image_height",  default: 0,  null: false
    t.string   "product_name",        default: "", null: false
    t.string   "creator",             default: "", null: false
    t.string   "manufacturer",        default: "", null: false
    t.string   "media",               default: "", null: false
    t.string   "release_date",        default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amazon_stocks", ["asin"], name: "index_amazon_stocks_on_asin", length: {"asin"=>10}, using: :btree

  create_table "article_contents", force: true do |t|
    t.integer  "article_id", null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_contents", ["article_id"], name: "index_article_contents_on_article_id", unique: true, using: :btree

  create_table "articles", force: true do |t|
    t.string   "title",                    null: false
    t.datetime "publish_at",               null: false
    t.integer  "access_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["access_count"], name: "index_articles_on_access_count", using: :btree
  add_index "articles", ["publish_at"], name: "index_articles_on_publish_at", using: :btree

  create_table "photos", force: true do |t|
    t.string   "image_file_name",    null: false
    t.string   "image_content_type", null: false
    t.integer  "image_file_size",    null: false
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["image_updated_at"], name: "index_photos_on_image_updated_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
