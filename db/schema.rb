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

ActiveRecord::Schema.define(version: 20170124143633) do

  create_table "amazons", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "asin"
    t.text     "url",              limit: 65535
    t.text     "medium_image_url", limit: 65535
    t.text     "small_image_url",  limit: 65535
    t.string   "product_name"
    t.string   "creator"
    t.string   "manufacturer"
    t.string   "media"
    t.string   "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["asin"], name: "index_amazons_on_asin", using: :btree
  end

  create_table "article_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id",               null: false
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_article_contents_on_article_id", unique: true, using: :btree
  end

  create_table "article_keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_article_keywords_on_article_id", using: :btree
    t.index ["keyword_id"], name: "index_article_keywords_on_keyword_id", using: :btree
  end

  create_table "article_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id", "photo_id"], name: "index_article_photos_on_article_id_and_photo_id", using: :btree
  end

  create_table "articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title",                    null: false
    t.datetime "publish_at",               null: false
    t.integer  "access_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["access_count"], name: "index_articles_on_access_count", using: :btree
    t.index ["publish_at"], name: "index_articles_on_publish_at", using: :btree
  end

  create_table "back_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image_file_name",    null: false
    t.string   "image_content_type", null: false
    t.integer  "image_file_size",    null: false
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.string   "name"
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id"], name: "index_comments_on_article_id", using: :btree
    t.index ["created_at"], name: "index_comments_on_created_at", using: :btree
  end

  create_table "delayed_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "priority",                 default: 0
    t.integer  "attempts",                 default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "facebook_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_facebooks_on_user_id", using: :btree
  end

  create_table "keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                                              collation: "utf8_bin"
    t.string   "body",       limit: 1000, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_keywords_on_name", unique: true, using: :btree
  end

  create_table "photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "image_file_name",    null: false
    t.string   "image_content_type", null: false
    t.integer  "image_file_size",    null: false
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["image_updated_at"], name: "index_photos_on_image_updated_at", using: :btree
  end

  create_table "related_articles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.integer  "related_article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["article_id", "related_article_id"], name: "index_related_articles_on_article_id_and_related_article_id", using: :btree
  end

  create_table "share_to_sns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_share_to_sns_on_article_id", using: :btree
    t.index ["created_at"], name: "index_share_to_sns_on_created_at", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",            default: "", null: false
    t.string   "password_digest",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
