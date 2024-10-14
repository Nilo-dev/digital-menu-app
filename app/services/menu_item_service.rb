class MenuItemService < BaseService
  def self.fetch_menu_items(menu_id)
    menu_item_menus = MenuItemMenu.where(menu_id: menu_id).includes(:menu_item)

    if data_present?(menu_item_menus)
      data = menu_item_menus.map do |item_menu|
        {
          id: item_menu.id,
          name: item_menu.menu_item.name,
          description: item_menu.description,
          price: item_menu.price
        }
      end

      { message: "Successful request", data: data, status: :ok }
    else
      { message: "No data for visualization", status: :not_found }
    end
  end

  def self.fetch_menu_item(id:, menu_id:)
    menu_item_menu = MenuItemMenu.includes(:menu_item).find_by(id: id, menu_id: menu_id)

    if data_present?(menu_item_menu)
      data = {
        id: menu_item_menu.id,
        name: menu_item_menu.menu_item.name,
        description: menu_item_menu.description,
        price: menu_item_menu.price
      }
      { message: "Successful request", data: data, status: :ok }
    else
      { message: "Data not found", status: :not_found }
    end
  end

  def self.create_menu_item(name:, description:, price:, menu_id:)
    initialize_variables(name: name, description: description, price: price, menu_id: menu_id)

    menu_item = MenuItem.find_or_initialize_by(name: @name)

    return { message: "Menu item must be valid before creating a relationship.", status: :unprocessable_entity } if menu_item.new_record? && !menu_item.valid?

    existing_relationship = MenuItemMenu.find_by(menu_item_id: menu_item.id, menu_id: @menu_id)
    return { message: "There's already a Menu Item called #{@name} on this Menu", status: :conflict } if existing_relationship

    begin
      menu_item.save! if menu_item.new_record?

      MenuItemMenu.create!(
        menu_item_id: menu_item.id,
        menu_id: @menu_id,
        description: @description,
        price: @price
      )
      { message: "Menu Item #{menu_item.name} successfully created for Menu ID #{@menu_id}.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to save the Menu Item", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  def self.update_menu_item(id:, menu_id:, name: nil, description: nil, price: nil)
    initialize_variables(id: id, name: name, description: description, price: price, menu_id: menu_id)
    return { message: "Nothing to update", status: :bad_request } if all_fields_blank?

    menu_item_menu = find_menu_item_menu
    return { message: "MenuItemMenu not found", status: :not_found } unless menu_item_menu

    if @name.present?
      menu_items = MenuItem.find_by("LOWER(name) LIKE ?", @name)
      if menu_items && menu_items.id != @id
        return { message: "Menu Item name must be unique.", status: :conflict }
      else
        menu_item = MenuItem.find_by(id: @id)
        menu_item.update(name: @name)
      end
    end

    update_params = { description: @description, price: @price }.reject { |_, value| value.blank? }

    begin
      menu_item_menu.update!(update_params) unless update_params.empty?
      { message: "MenuItemMenu ID #{menu_item_menu.id} successfully updated.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to update the MenuItem or MenuItemMenu", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  private

  def self.all_fields_blank?
    @name.blank? && @description.blank? && @price.blank?
  end

  def self.find_menu_item_menu
    MenuItemMenu.find_by(menu_item_id: @id, menu_id: @menu_id)
  end

  def self.initialize_variables(id: nil, name:, description:, price:, menu_id:)
    @id = id.to_i
    @name = name
    @description = description
    @price = price
    @menu_id = menu_id
  end
end
