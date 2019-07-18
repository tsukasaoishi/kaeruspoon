class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.string :image_file_name, null: false
      t.string :image_content_type, null: false
      t.integer :image_file_size, null: false
      t.datetime :image_updated_at

      t.timestamps
    end
    add_index :photos, :image_updated_at
  end
end
