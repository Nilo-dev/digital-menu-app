require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  let(:menu_item) { build(:menu_item) }

  describe 'validations' do
    it 'is valid with a name' do
      expect(menu_item).to be_valid
    end

    it 'is invalid without a name' do
      menu_item.name = nil
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid if the name is not unique' do
      create(:menu_item, name: 'Unique Item')
      menu_item.name = 'Unique Item'
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it { should have_many(:menu_item_menus).dependent(:destroy) }
    it { should have_many(:menus).through(:menu_item_menus) }
  end
end
