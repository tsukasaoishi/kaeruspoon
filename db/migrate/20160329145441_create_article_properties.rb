class CreateArticleProperties < ActiveRecord::Migration
  def change
    create_table :article_properties do |t|
      t.references :article
      t.boolean :not_to_share, null: false, default: false

      t.timestamps null: false
    end

    add_index :article_properties, :article_id
  end
end
