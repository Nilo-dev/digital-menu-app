class AddUniqueIndexToMenuItemsName < ActiveRecord::Migration[7.2]
  def change
    add_index :menu_items, :name, unique: true
  end
end
