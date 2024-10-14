class RestaurantsController < ApplicationController
  before_action :set_restaurant_id, only: [ :show, :update ]
  before_action :set_restaurant_params, only: [ :update ]

  def index
    response = RestaurantService.fetch_restaurants
    render json: response, status: response[:status]
  end

  def show
    response = RestaurantService.fetch_restaurant(@restaurant_id)
    render json: response, status: response[:status]
  end

  def create
    response = RestaurantService.create_restaurant(restaurant_params[:name])
    render json: response, status: response[:status]
  end

  def update
    response = RestaurantService.update_restaurant(id: @restaurant_id, name: @restaurant_name)
    render json: response, status: response[:status]
  end

  private

  def restaurant_params
    params.permit(:name)
  end

  def set_restaurant_id
    @restaurant_id = params[:id]
    render json: { message: "Restaurant not found", status: :not_found }, status: :not_found unless Restaurant.exists?(id: @restaurant_id)
  end

  def set_restaurant_params
    @restaurant_name = restaurant_params[:name]
  end
end
