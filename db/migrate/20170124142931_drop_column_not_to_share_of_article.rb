class DropColumnNotToShareOfArticle < ActiveRecord::Migration[5.0]
  def change
    remove_column :articles, :not_to_share
  end
end