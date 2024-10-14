class AddRestauranteIdToMenu < ActiveRecord::Migration[7.2]
  def change
    add_reference :menus, :restaurant, foreign_key: true
  end
end
