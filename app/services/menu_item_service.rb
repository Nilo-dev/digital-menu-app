class MenuItemService
  def self.fetch_menu_items(menu_id)
    menu_items = MenuItem.where(menu_id: menu_id)
    if data_present?(menu_items)
      { message: "Successful request", data: menu_items, status: :ok }
    else
      { message: "No data for visualization", status: :not_found }
    end
  end

  def self.fetch_menu_item(id)
    menu_item = MenuItem.find_by(id: id)
    if data_present?(menu_item)
      { message: "Successful request", data: menu_item, status: :ok }
    else
      { message: "Data not found", status: :not_found }
    end
  end

  def self.create_menu_item(name:, description:, price:, menu_id:)
    menu_item = MenuItem.new(name: name, description: description, price: price, menu_id: menu_id)
    begin
      menu_item.save!
      { message: "Menu Item #{menu_item.name} successfully created.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to save the Menu Item", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  def self.update_menu_item(id:, name: nil, description: nil, price: nil)
    return { message: "Nothing to update", status: :bad_request } if name.blank? && description.blank? && price.blank?

    menu_item = MenuItem.find_by(id: id)
    return { message: "Menu Item not found", status: :not_found } unless data_present?(menu_item)

    update_params = { name: name, description: description, price: price }.reject { |_, value| value.blank? }

    begin
      menu_item.update!(update_params)
      { message: "Menu item #{menu_item.name} successfully updated.", status: :ok }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  private

  def self.data_present?(data)
    data.present?
  end

  def self.format_error_message(base_message, error)
    "#{base_message}: #{error.message}"
  end
end
