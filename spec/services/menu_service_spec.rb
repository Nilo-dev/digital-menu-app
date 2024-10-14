require 'rails_helper'

RSpec.describe MenuService do
  let!(:restaurant) { Restaurant.create(name: 'Test Restaurant') }
  let!(:menu) { Menu.create(name: 'Test Menu', restaurant_id: restaurant.id) }

  describe '.fetch_menus' do
    it 'returns menus when present' do
      response = MenuService.fetch_menus(restaurant.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:data]).to include(menu)
    end

    it 'returns not_found when no menus are present' do
      Menu.destroy_all
      response = MenuService.fetch_menus(restaurant.id)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("No data for visualization")
    end
  end

  describe '.fetch_menu' do
    it 'returns the menu when it exists' do
      response = MenuService.fetch_menu(id: menu.id, restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:data]).to eq(menu)
    end

    it 'returns not_found when the menu does not exist' do
      response = MenuService.fetch_menu(id: 999, restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("Data not found")
    end
  end

  describe '.create_menu' do
    it 'creates a menu successfully' do
      response = MenuService.create_menu(name: 'New Menu', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:message]).to include("Menu New Menu successfully created.")
    end

    it 'returns unprocessable_entity when menu is invalid' do
      response = MenuService.create_menu(name: '', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:unprocessable_entity)
      expect(response[:message]).to include("Error when trying to save the Menu")
    end

    it 'returns internal_server_error on unexpected error' do
      allow_any_instance_of(Menu).to receive(:save!).and_raise(StandardError, "Unexpected error")
      response = MenuService.create_menu(name: 'New Menu', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:internal_server_error)
      expect(response[:message]).to include("An unexpected error occurred")
    end
  end

  describe '.update_menu' do
    it 'updates the menu successfully' do
      response = MenuService.update_menu(id: menu.id, name: 'Updated Menu', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:ok)
      expect(response[:message]).to include("Menu Updated Menu successfully updated.")
      menu.reload
      expect(menu.name).to eq('Updated Menu')
    end

    it 'returns not_found when the menu does not exist' do
      response = MenuService.update_menu(id: 999, name: 'Updated Menu', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:not_found)
      expect(response[:message]).to eq("Menu not found")
    end

    it 'returns unprocessable_entity when update is invalid' do
      response = MenuService.update_menu(id: menu.id, name: '', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:unprocessable_entity)
      expect(response[:message]).to include("Error when trying to update the Menu")
    end

    it 'returns internal_server_error on unexpected error' do
      allow_any_instance_of(Menu).to receive(:update!).and_raise(StandardError, "Unexpected error")
      response = MenuService.update_menu(id: menu.id, name: 'Updated Menu', restaurant_id: restaurant.id)
      expect(response[:status]).to eq(:internal_server_error)
      expect(response[:message]).to include("An unexpected error occurred")
    end
  end
end
