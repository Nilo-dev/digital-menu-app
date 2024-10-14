class RestaurantService < BaseService
  def self.fetch_restaurants
    restaurants = Restaurant.all
    if data_present?(restaurants)
      { message: "Successful request", data: restaurants, status: :ok }
    else
      { message: "No data for visualization", status: :not_found }
    end
  end

  def self.fetch_restaurant(id)
    restaurant = Restaurant.find_by(id: id)
    if data_present?(restaurant)
      { message: "Successful request", data: restaurant, status: :ok }
    else
      { message: "Data not found", status: :not_found }
    end
  end

  def self.create_restaurant(name)
    restaurant = Restaurant.new(name: name)
    begin
      restaurant.save!
      { message: "Restaurant #{restaurant.name} successfully created.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to save the restaurant", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end

  def self.update_restaurant(id:, name:)
    restaurant = Restaurant.find_by(id: id)
    return { message: "Restaurant not found", status: :not_found } unless data_present?(restaurant)

    begin
      restaurant.update!(name: name)
      { message: "Restaurant #{restaurant.name} successfully updated.", status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { message: format_error_message("Error when trying to update the restaurant", e), status: :unprocessable_entity }
    rescue StandardError => e
      { message: format_error_message("An unexpected error occurred", e), status: :internal_server_error }
    end
  end
end
