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
    it { should have_many(:menu_items) }

    it 'destroys associated menu_items when menu is destroyed' do
      create(:menu_item, menu: menu)
      expect { menu.destroy }.to change { MenuItem.count }.by(-1)
    end
  end
end
