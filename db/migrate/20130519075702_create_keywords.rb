class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :name, :null => false, :default => ""
      t.string :body, :limit => 1000, :null => false, :default => ""

      t.timestamps
    end
    execute("ALTER TABLE keywords MODIFY name varchar(255) CHARACTER SET utf8 COLLATE utf8_bin;")
    add_index :keywords, :name, :unique => true
  end
end
