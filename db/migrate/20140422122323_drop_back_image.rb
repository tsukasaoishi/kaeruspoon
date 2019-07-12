class DropBackImage < ActiveRecord::Migration[5.2]
  def change
    drop_table :back_images
  end
end
