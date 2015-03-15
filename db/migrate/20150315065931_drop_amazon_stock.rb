class DropAmazonStock < ActiveRecord::Migration
  def change
    drop_table :amazon_stocks
  end
end
