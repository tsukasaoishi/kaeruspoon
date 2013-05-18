class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false, :default => ""
      t.string :password_digest, :null => false

      t.timestamps
    end

    add_index :user, :name, :unique => true
  end
end
