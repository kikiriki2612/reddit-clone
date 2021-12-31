class AddSlugToSubs < ActiveRecord::Migration[5.2]
  def change
    add_column :subs, :slug, :string
    add_index :subs, :slug, unique: true
  end
end
