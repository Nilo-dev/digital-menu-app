# Example usage:
# rails runner update_menu_restaurant_runner.rb menu_array restaurant_id
# rails runner update_menu_restaurant_runner.rb 1 5


def update_menu_with_restaurant_id(menu_ids, restaurant_id)
  unless Restaurant.exists?(restaurant_id)
    Rails.logger.error "Restaurant with ID #{restaurant_id} does not exist."
    return
  end

  Menu.transaction do
    menus = Menu.where(id: menu_ids)

    if menus.empty?
      Rails.logger.info "No menus found with the provided IDs: #{menu_ids}"
      return
    end

    menus.each do |menu|
      if menu.update(restaurant_id: restaurant_id)
        Rails.logger.info "Menu ID #{menu.id} successfully updated with restaurant_id #{restaurant_id}."
      else
        Rails.logger.error "Failed to update Menu ID #{menu.id}: #{menu.errors.full_messages.join(', ')}"
        raise ActiveRecord::Rollback, "Failed to update all menus. Transaction rolled back."
      end
    end

    Rails.logger.info "Update completed for the provided menus."
  end
rescue => e
  Rails.logger.error "An error occurred during the update: #{e.message}"
end

update_menu_with_restaurant_id(ARGV[0], ARGV[1])
