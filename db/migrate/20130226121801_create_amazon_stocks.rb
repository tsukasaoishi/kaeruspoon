class CreateAmazonStocks < ActiveRecord::Migration
  def change
    create_table :amazon_stocks do |t|
      t.string :asin, :null => false
      t.string :url, :null => false, :limit => 2048
      t.string :medium_image_url, :null => false, :default => ""
      t.integer :medium_image_width, :null => false, :default => 0
      t.integer :medium_image_height, :null => false, :default => 0
      t.string :small_image_url, :null => false, :default => ""
      t.integer :small_image_width, :null => false, :default => 0
      t.integer :small_image_height, :null => false, :default => 0
      t.string :product_name, :null => false, :default => ""
      t.string :creator, :null => false, :default => ""
      t.string :manufacturer, :null => false, :default => ""
      t.string :media, :null => false, :default => ""
      t.string :release_date, :null => false, :default => ""

      t.timestamps
    end
    add_index :amazon_stocks, :asin, length: 10
  end
end
