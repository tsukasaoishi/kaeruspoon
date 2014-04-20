class CreateArticlePhotos < ActiveRecord::Migration
  def change
    create_table :article_photos do |t|
      t.integer :article_id
      t.integer :photo_id

      t.timestamps
    end

    add_index :article_photos, [:article_id, :photo_id]
  end
end
