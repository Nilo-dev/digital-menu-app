class MenusController < ApplicationController
  before_action :set_menu_params, only: [ :update ]
  before_action :set_menu_id, only: [ :show, :update ]
  before_action :set_restaurant_id, only: [ :index, :show, :create, :update ]

  def index
    response = MenuService.fetch_menus(@restaurant_id)
    render json: response, status: response[:status]
  end

  def show
    response = MenuService.fetch_menu(id: @menu_id, restaurant_id: @restaurant_id)
    render json: response, status: response[:status]
  end

  def create
    response = MenuService.create_menu(name: menu_params[:name], restaurant_id: @restaurant_id)
    render json: response, status: response[:status]
  end

  def update
    response = MenuService.update_menu(id: @menu_id, name: @menu_name, restaurant_id: @restaurant_id)
    render json: response, status: response[:status]
  end

  private

  def menu_params
    params.permit(:name)
  end

  def set_restaurant_id
    @restaurant_id = params[:restaurant_id]
    render json: { message: "Restaurant not found", status: :not_found }, status: :not_found unless Restaurant.exists?(id: @restaurant_id)
  end

  def set_menu_id
    @menu_id = params[:id]
    render json: { message: "Menu not found", status: :not_found }, status: :not_found unless Menu.exists?(id: @menu_id)
  end

  def set_menu_params
    @menu_name = menu_params[:name]
  end
end
