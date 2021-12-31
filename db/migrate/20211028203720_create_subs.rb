class CreateSubs < ActiveRecord::Migration[5.2]
  def change
    create_table :subs do |t|
      t.integer :moderator_id, null: false
      t.string :title, null: false 
      t.text :description

      t.timestamps
    end
    add_index :subs, :moderator_id
    add_index :subs, :title, unique: true
  end
end
