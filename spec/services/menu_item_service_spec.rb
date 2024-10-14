require 'rails_helper'

RSpec.describe MenuItemService do
  let(:valid_attributes) { { name: 'Pizza', description: 'Delicious cheese pizza', price: 12.99 } }
  let(:invalid_attributes) { { name: '', description: 'Invalid item', price: nil } }
  let(:existing_id) { 1 }
  let(:non_existing_id) { 9999 }
  let(:menu_id) { 1 }

  describe '.create_menu_item' do
    xit 'creates a menu item successfully' do
      response = MenuItemService.create_menu_item(valid_attributes)
      expect(response[:status]).to eq(:created)
      expect(response[:data]).to include(:id, :name, :description, :price)
    end

    xit 'returns unprocessable_entity when invalid' do
      response = MenuItemService.create_menu_item(invalid_attributes)
      expect(response[:message]).to include("Menu item must be valid before creating a relationship.")
    end
  end

  describe '.fetch_menu_item' do
    xit 'returns not found when the menu item does not exist' do
      response = MenuItemService.fetch_menu_item(id: non_existing_id, menu_id: menu_id)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to include("Menu item not found.")
    end

    it 'returns a menu item when it exists' do
      response = MenuItemService.fetch_menu_item(id: existing_id, menu_id: menu_id)
      expect(response[:status]).to eq(:ok)
      expect(response[:data]).to include(:id, :name, :description, :price)
    end
  end

  describe '.update_menu_item' do
    xit 'updates a menu item successfully' do
      response = MenuItemService.update_menu_item(existing_id, valid_attributes)
      expect(response[:status]).to eq(:ok)
    end

    xit 'handles unexpected errors' do
      allow(MenuItemMenu).to receive(:find_by).and_raise(StandardError)
      response = MenuItemService.update_menu_item(existing_id, valid_attributes)
      expect(response[:status]).to eq(:internal_server_error)
    end
  end
end
