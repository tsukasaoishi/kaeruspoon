class CreateShareToSns < ActiveRecord::Migration[5.2]
  def change
    create_table :share_to_sns do |t|
      t.references :article
      t.timestamps
    end

    add_index :share_to_sns, :created_at
  end
end
