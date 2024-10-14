class MenusController < ApplicationController
  before_action :set_menu_params, only: [ :update ]
  before_action :set_menu_id, only: [ :show, :update ]

  def index
    response = MenuService.fetch_menus
    render json: response, status: response[:status]
  end

  def show
    response = MenuService.fetch_menu(@menu_id)
    render json: response, status: response[:status]
  end

  def create
    response = MenuService.create_menu(menu_params[:name])
    render json: response, status: response[:status]
  end

  def update
    response = MenuService.update_menu(id: @menu_id, name: @menu_name)
    render json: response, status: response[:status]
  end

  private

  def menu_params
    params.permit(:name)
  end

  def set_menu_id
    @menu_id = params[:id]
    render json: { message: "Menu not found", status: :not_found }, status: :not_found unless Menu.exists?(@menu_id)
  end

  def set_menu_params
    @menu_name = menu_params[:name]
  end
end
