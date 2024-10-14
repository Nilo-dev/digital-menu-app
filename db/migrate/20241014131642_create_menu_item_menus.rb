class CreateMenuItemMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_item_menus do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :menu_item, null: false, foreign_key: true
      t.string :description
      t.decimal :price

      t.timestamps
    end
  end
end
