# Example usage:
# rails runner lib/tasks/migrate_menu_items_to_menu_item_menus_runner.rb

puts "Started migrate_menu_items_to_menu_item_menus_runner.rb runner"

def create_menu_item_menus_from_menu_item
  MenuItem.find_each do |menu_item|
    MenuItemMenu.create!(
      menu_id: menu_item.menu_id,
      menu_item_id: menu_item.id,
      description: menu_item.description,
      price: menu_item.price
    )
    Rails.logger.info "Migrated MenuItem ID #{menu_item.id} to MenuItemMenu."
  end

  Rails.logger.info "Migration of MenuItems to MenuItemMenus completed."
rescue => e
  Rails.logger.error "An error occurred during migration: #{e.message}"
end

create_menu_item_menus_from_menu_item

puts "Ending migrate_menu_items_to_menu_item_menus_runner.rb runner"
