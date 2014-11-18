class RemoveColumnCategoryAtArticle < ActiveRecord::Migration
  def change
    remove_index :articles, [:category, :publish_at]
    remove_column :articles, :category
  end
end
