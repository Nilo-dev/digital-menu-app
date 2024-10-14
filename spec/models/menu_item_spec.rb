require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  let(:menu_item) { create(:menu_item) }

  describe 'validations' do
    it 'is valid with a name, price, and description' do
      expect(menu_item).to be_valid
    end

    it 'is invalid without a name' do
      menu_item.name = nil
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      menu_item.price = nil
      expect(menu_item).not_to be_valid
      expect(menu_item.errors[:price]).to include("can't be blank")
    end

    it 'is invalid without a description' do
      menu_item.description = nil
      expect(menu_item).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:menu) }
  end
end
