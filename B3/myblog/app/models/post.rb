class Post < ApplicationRecord
  has_many :comments
  validates :title, presence: true
  validates :author, presence: true
  validates :text, presence: true, length: { minimum: 10 }
end
