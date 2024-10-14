require 'rails_helper'

RSpec.describe Menu, type: :model do
  let(:menu) { create(:menu) }

  describe 'validations' do
    it 'is valid with a name' do
      expect(menu).to be_valid
    end

    it 'is invalid without a name' do
      menu.name = nil
      expect(menu).not_to be_valid
      expect(menu.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { should belong_to(:restaurant) }
    it { should have_many(:menu_item_menus).dependent(:destroy) }
    it { should have_many(:menu_items).through(:menu_item_menus) }

    it 'destroys associated menu_item_menus when menu is destroyed' do
      create(:menu_item_menu, menu: menu)
      expect { menu.destroy }.to change { MenuItemMenu.count }.by(-1)
    end

    it 'can access associated menu_items through menu_item_menus' do
      menu_item = create(:menu_item)
      create(:menu_item_menu, menu: menu, menu_item: menu_item)
      expect(menu.menu_items).to include(menu_item)
    end
  end
end
