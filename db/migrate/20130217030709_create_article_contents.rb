class CreateArticleContents < ActiveRecord::Migration
  def change
    create_table :article_contents do |t|
      t.integer :article_id, :null => false
      t.text :body
      t.timestamps
    end

    add_index :article_contents, :article_id, :unique => true
  end
end
