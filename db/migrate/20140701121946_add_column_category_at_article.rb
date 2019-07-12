class AddColumnCategoryAtArticle < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :category, :integer, :null => false, :default => 0
    add_index :articles, [:category, :publish_at]
  end
end
