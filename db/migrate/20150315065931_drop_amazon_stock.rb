class DropAmazonStock < ActiveRecord::Migration[5.2]
  def change
    drop_table :amazon_stocks
  end
end
