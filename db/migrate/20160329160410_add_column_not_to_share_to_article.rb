class AddColumnNotToShareToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :not_to_share, :boolean, null: false, default: false, after: :access_count
  end
end
