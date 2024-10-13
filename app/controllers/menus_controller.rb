class MenusController < ApplicationController
  def index
    response = MenuService.fetch_menus
    render json: response, status: response[:status]
  end

  def show
    response = MenuService.fetch_menu(params[:id])
    render json: response, status: response[:status]
  end

  def create
    response = MenuService.create_menu(params[:name])
    render json: response, status: response[:status]
  end

  def update
    response = MenuService.update_menu(id: params[:id], name: params[:name])
    render json: response, status: response[:status]
  end
end
