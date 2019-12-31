class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: {maximum:32}
  validates :title, presence: true

  validate :validate_content_lenght

  MAX_CONTENT_LENGHT = 50

  def validate_content_lenght
    length = content.to_plain_text.size

    if length > MAX_CONTENT_LENGHT
      errors.add(
        :content, 
        :too_long, 
        max_content_lenght: MAX_CONTENT_LENGHT,
        length: length
      )
    end
  end

end
