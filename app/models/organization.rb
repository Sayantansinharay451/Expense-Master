class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  # validates :name, presence: true, uniqueness: true, length: { minimum: 10 }
end
