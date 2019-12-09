class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: {maximum:32}
  validates :title, presence: true
end
