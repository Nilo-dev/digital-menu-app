require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  let!(:menu) { create(:menu) }
  let!(:menu_item) { create(:menu_item, menu: menu) }

  describe "GET #index" do
    it "returns a success response with menu items" do
      get :index, params: { menu_id: menu.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(1)
    end

    it "returns a not found response when menu does not exist" do
      get :index, params: { menu_id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu not found")
    end
  end

  describe "GET #show" do
    it "returns a success response for a menu item" do
      get :show, params: { menu_id: menu.id, id: menu_item.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["id"]).to eq(menu_item.id)
    end

    it "returns a not found response when menu item does not exist" do
      get :show, params: { menu_id: menu.id, id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu Item not found")
    end
  end

  describe "POST #create" do
    it "creates a menu item and returns a success response" do
      expect {
        post :create, params: { menu_id: menu.id, name: "New Item", description: "Delicious", price: 10.0 }
      }.to change(MenuItem, :count).by(1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to include("successfully created")
    end

    it "returns an error response when params are invalid" do
      post :create, params: { menu_id: menu.id, name: "", description: "Delicious", price: 10.0 }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["message"]).to include("Error when trying to save the Menu Item")
    end
  end

  describe "PATCH #update" do
    it "updates a menu item and returns a success response" do
      patch :update, params: { menu_id: menu.id, id: menu_item.id, name: "Updated Item" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to include("successfully updated")
      expect(menu_item.reload.name).to eq("Updated Item")
    end

    it "returns a not found response when menu item does not exist" do
      patch :update, params: { menu_id: menu.id, id: 999, name: "Updated Item" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu Item not found")
    end

    it "returns a bad request response when nothing to update" do
      patch :update, params: { menu_id: menu.id, id: menu_item.id }
      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)["message"]).to eq("Nothing to update")
    end
  end
end
