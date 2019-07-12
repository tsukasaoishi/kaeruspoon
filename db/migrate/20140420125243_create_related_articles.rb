class CreateRelatedArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :related_articles do |t|
      t.integer :article_id
      t.integer :related_article_id

      t.timestamps
    end

    add_index :related_articles, [:article_id, :related_article_id]
  end
end
