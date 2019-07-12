class CreateArticleKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :article_keywords do |t|
      t.integer :article_id
      t.integer :keyword_id

      t.timestamps
    end

    add_index :article_keywords, :article_id
    add_index :article_keywords, :keyword_id
  end
end
