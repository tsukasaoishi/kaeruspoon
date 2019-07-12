class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, :null => false
      t.datetime :publish_at, :null => false
      t.integer :access_count, :null => false, :default => 0
      t.timestamps
    end
    add_index :articles, :publish_at
    add_index :articles, :access_count
  end
end
