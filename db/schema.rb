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

ActiveRecord::Schema.define(version: 20130217030709) do

  create_table "article_contents", force: true do |t|
    t.integer  "article_id", null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_contents", ["article_id"], name: "index_article_contents_on_article_id", unique: true

  create_table "articles", force: true do |t|
    t.string   "title",                    null: false
    t.datetime "publish_at",               null: false
    t.integer  "access_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["access_count"], name: "index_articles_on_access_count"
  add_index "articles", ["publish_at"], name: "index_articles_on_publish_at"

end
