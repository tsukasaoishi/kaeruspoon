class CreateKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.string :name, null: false, default: ""
      t.string :body, limit: 1000, null: false, default: ""

      t.timestamps
    end
    add_index :keywords, :name, unique: true
  end
end
