class MenuService
  def self.fetch_menus
    menus = Menu.all
    if data_present?(menus)
      { message: "Successful request", data: menus, status: :ok }
    else
      { message: "No data for visualization", status: :not_found }
    end
  end

  def self.fetch_menu(id)
    menu = Menu.find_by(id: id)
    if data_present?(menu)
      { message: "Successful request", data: menu, status: :ok }
    else
      { message: "Data not found", status: :not_found }
    end
  end

  def self.create_menu(name)
    menu = Menu.new(name: name)
    begin
      menu.save!
      { message: "Menu #{menu.name} successfully created.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to save the Menu", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  def self.update_menu(id:, name:)
    menu = Menu.find_by(id: id)

    return { message: "Menu not found", status: :not_found } unless data_present?(menu)

    begin
      menu.update!(name: name)
      { message: "Menu #{menu.name} successfully updated.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to update the Menu", e), status: :unprocessable_entity }
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
