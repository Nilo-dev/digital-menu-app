class MenuItem < ApplicationRecord
  has_many :menu_item_menus, dependent: :destroy
  has_many :menus, through: :menu_item_menus

  validates :name, presence: true, uniqueness: true
end
