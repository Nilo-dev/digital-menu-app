class RemoveFieldsFromMenuItem < ActiveRecord::Migration[7.2]
  def change
    remove_column :menu_items, :description, :text
    remove_column :menu_items, :price, :decimal
    remove_reference :menu_items, :menu, foreign_key: true
  end
end
