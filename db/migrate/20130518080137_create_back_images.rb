class CreateBackImages < ActiveRecord::Migration
  def change
    create_table :back_images do |t|
      t.string :image_file_name, :null => false
      t.string :image_content_type, :null => false
      t.integer :image_file_size, :null => false
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
