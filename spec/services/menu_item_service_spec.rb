require 'rails_helper'

RSpec.describe MenuItemService do
  let!(:menu) { create(:menu) }
  let!(:menu_item) { create(:menu_item, menu: menu) }

  describe ".fetch_menu_items" do
    it "returns menu items when they exist" do
      response = MenuItemService.fetch_menu_items(menu.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:data]).to include(menu_item)
    end

    it "returns not found when no menu items exist" do
      MenuItem.delete_all
      response = MenuItemService.fetch_menu_items(menu.id)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("No data for visualization")
    end
  end

  describe ".fetch_menu_item" do
    it "returns a menu item when it exists" do
      response = MenuItemService.fetch_menu_item(menu_item.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:data]).to eq(menu_item)
    end

    it "returns not found when the menu item does not exist" do
      response = MenuItemService.fetch_menu_item(999)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("Data not found")
    end
  end

  describe ".create_menu_item" do
    it "creates a menu item successfully" do
      response = MenuItemService.create_menu_item(name: "New Item", description: "Delicious", price: 10.0, menu_id: menu.id)
      expect(response[:status]).to eq(:ok)
      expect(MenuItem.last.name).to eq("New Item")
    end

    it "returns unprocessable_entity when invalid" do
      response = MenuItemService.create_menu_item(name: "", description: "Delicious", price: 10.0, menu_id: menu.id)
      expect(response[:status]).to eq(:unprocessable_entity)
      expect(response[:message]).to include("Error when trying to save the Menu Item")
    end

    it "handles unexpected errors" do
      allow_any_instance_of(MenuItem).to receive(:save!).and_raise(StandardError, "Unexpected error")
      response = MenuItemService.create_menu_item(name: "New Item", description: "Delicious", price: 10.0, menu_id: menu.id)
      expect(response[:status]).to eq(:internal_server_error)
      expect(response[:message]).to include("An unexpected error occurred")
    end
  end

  describe ".update_menu_item" do
    it "updates a menu item successfully" do
      response = MenuItemService.update_menu_item(id: menu_item.id, name: "Updated Item")
      expect(response[:status]).to eq(:ok)
      expect(menu_item.reload.name).to eq("Updated Item")
    end

    it "returns not found when menu item does not exist" do
      response = MenuItemService.update_menu_item(id: 999, name: "Updated Item")
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("Menu Item not found")
    end

    it "returns bad_request when nothing to update" do
      response = MenuItemService.update_menu_item(id: menu_item.id)
      expect(response[:status]).to eq(:bad_request)
      expect(response[:message]).to eq("Nothing to update")
    end

    it "handles unexpected errors" do
      allow_any_instance_of(MenuItem).to receive(:update!).and_raise(StandardError, "Unexpected error")
      response = MenuItemService.update_menu_item(id: menu_item.id, name: "Updated Item")
      expect(response[:status]).to eq(:internal_server_error)
      expect(response[:message]).to include("An unexpected error occurred")
    end
  end
end
