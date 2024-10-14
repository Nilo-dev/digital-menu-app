class MenuItemsController < ApplicationController
  before_action :set_menu_item_params, only: [ :create, :update ]
  before_action :set_menu_item_id, only: [ :show, :update ]
  before_action :set_menu_id, only: [ :index, :create ]

  def index
    response = MenuItemService.fetch_menu_items(@menu_id)
    render json: response, status: response[:status]
  end

  def show
    response = MenuItemService.fetch_menu_item(@menu_item_id)
    render json: response, status: response[:status]
  end

  def create
    response = MenuItemService.create_menu_item(
      name: @menu_item[:name],
      description: @menu_item[:description],
      price: @menu_item[:price],
      menu_id: @menu_id
    )

    render json: response, status: response[:status]
  end

  def update
    response = MenuItemService.update_menu_item(
      id: @menu_item_id,
      name: @menu_item[:name],
      description: @menu_item[:description],
      price: @menu_item[:price]
    )

    render json: response, status: response[:status]
  end

  private

  def set_menu_id
    @menu_id = params[:menu_id]
    render json: { message: "Menu not found", status: :not_found }, status: :not_found unless Menu.exists?(id: @menu_id)
  end

  def set_menu_item_id
    @menu_item_id = params[:id]
    render json: { message: "Menu Item not found", status: :not_found }, status: :not_found unless MenuItem.exists?(id: @menu_item_id)
  end

  def set_menu_item_params
    @menu_item = params.permit(:name, :description, :price)
  end
end
