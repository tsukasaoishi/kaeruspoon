class RemoveColumnCategoryAtArticle < ActiveRecord::Migration[5.2]
  def change
    remove_index :articles, [:category, :publish_at]
    remove_column :articles, :category
  end
end
