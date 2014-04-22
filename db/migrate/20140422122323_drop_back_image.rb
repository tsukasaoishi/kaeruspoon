class DropBackImage < ActiveRecord::Migration
  def change
    drop_table :back_images
  end
end
