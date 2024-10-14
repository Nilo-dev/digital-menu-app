require 'rails_helper'

RSpec.describe MenusController, type: :controller do
  let!(:restaurant) { Restaurant.create(name: "Test Restaurant") }
  let!(:menu) { Menu.create(name: "Test Menu", restaurant: restaurant) }

  describe 'GET #index' do
    it 'returns a successful response with all menus' do
      get :index, params: { restaurant_id: restaurant.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].length).to eq(Menu.where(restaurant: restaurant).count)
    end

    it 'returns a not_found response when no menus exist' do
      Menu.destroy_all
      get :index, params: { restaurant_id: restaurant.id }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("No data for visualization")
    end
  end

  describe 'GET #show' do
    it 'returns a successful response with the requested menu' do
      get :show, params: { id: menu.id, restaurant_id: restaurant.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["name"]).to eq(menu.name)
    end

    it 'returns a not_found response when the menu does not exist' do
      get :show, params: { id: 999, restaurant_id: restaurant.id }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu not found")
    end
  end

  describe 'POST #create' do
    it 'creates a new menu and returns a successful response' do
      expect {
        post :create, params: { name: "New Menu", restaurant_id: restaurant.id }
      }.to change(Menu, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Menu New Menu successfully created.")
    end

    it 'returns an unprocessable_entity response when name is blank' do
      post :create, params: { name: "", restaurant_id: restaurant.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["message"]).to include("Error when trying to save the Menu: Validation failed: Name can't be blank")
    end
  end

  describe 'PUT #update' do
    it 'updates an existing menu and returns a successful response' do
      put :update, params: { id: menu.id, name: "Updated Menu", restaurant_id: restaurant.id }
      menu.reload

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Menu Updated Menu successfully updated.")
      expect(menu.name).to eq("Updated Menu")
    end

    it 'returns a not_found response when the menu does not exist' do
      put :update, params: { id: 999, name: "Attempted Update", restaurant_id: restaurant.id }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu not found")
    end

    it 'returns an internal_server_error response for unexpected errors' do
      allow_any_instance_of(Menu).to receive(:update!).and_raise(StandardError)
      put :update, params: { id: menu.id, name: "Attempted Update", restaurant_id: restaurant.id }
      expect(response).to have_http_status(:internal_server_error)
      expect(JSON.parse(response.body)["message"]).to include("An unexpected error occurred")
    end
  end
end
