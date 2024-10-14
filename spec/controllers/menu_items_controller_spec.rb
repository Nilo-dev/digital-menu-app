require 'rails_helper'

RSpec.describe MenuItemsController, type: :controller do
  let!(:restaurant) { create(:restaurant) }
  let!(:menu) { create(:menu, restaurant: restaurant) }
  let!(:menu_item) { create(:menu_item) }

  before do
    create(:menu_item_menu, menu_item: menu_item, menu: menu)
  end

  describe "GET #index" do
    it "returns a success response with menu items" do
      get :index, params: { restaurant_id: restaurant.id, menu_id: menu.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"].size).to eq(1)
    end

    it "returns a not found response when menu does not exist" do
      get :index, params: { restaurant_id: restaurant.id, menu_id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu not found")
    end
  end

  describe "GET #show" do
    xit "returns a success response for a menu item" do
      get :show, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: menu_item.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["data"]["id"]).to eq(menu_item.id)
    end

    it "returns a not found response when menu item does not exist" do
      get :show, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["message"]).to eq("Menu Item not found")
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      xit "creates a menu item and returns a success response" do
        expect {
          post :create, params: { restaurant_id: restaurant.id, menu_id: menu.id, menu_item: { name: "New Item", description: "Delicious", price: 10.0 } }
        }.to change(MenuItem, :count).by(1)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to include("successfully created")
      end
    end

    context "with invalid parameters" do
      it "returns an error response when the name is blank" do
        post :create, params: { restaurant_id: restaurant.id, menu_id: menu.id, menu_item: { name: "", description: "Delicious", price: 10.0 } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["message"]).to include("Menu item must be valid before creating a relationship.")
      end

      xit "returns a conflict response when the menu item already exists in the menu" do
        post :create, params: { restaurant_id: restaurant.id, menu_id: menu.id, menu_item: { name: menu_item.name, description: "Delicious", price: 10.0 } }
        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)["message"]).to include("There's already a Menu Item called #{menu_item.name} on this Menu")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      xit "updates a menu item and returns a success response" do
        patch :update, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: menu_item.id, menu_item: { name: "Updated Item" } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to include("successfully updated")
        expect(menu_item.reload.name).to eq("Updated Item")
      end
    end

    context "with invalid parameters" do
      it "returns a not found response when the menu item does not exist" do
        patch :update, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: 999, menu_item: { name: "Updated Item" } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["message"]).to eq("Menu Item not found")
      end

      it "returns a bad request response when nothing to update" do
        patch :update, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: menu_item.id }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["message"]).to include("Nothing to update")
      end

      xit "returns a conflict response when the new name already exists" do
        existing_menu_item = create(:menu_item, name: "Existing Item")
        create(:menu_item_menu, menu_item: existing_menu_item, menu: menu)

        patch :update, params: { restaurant_id: restaurant.id, menu_id: menu.id, id: menu_item.id, menu_item: { name: "Existing Item" } }
        expect(response).to have_http_status(:conflict)
        expect(JSON.parse(response.body)["message"]).to include("Menu Item name must be unique.")
      end
    end
  end
end
