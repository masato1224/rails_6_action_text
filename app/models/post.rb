class Post < ApplicationRecord
  has_rich_text :content

  validates :title, length: {maximum:32}
  validates :title, presence: true

  validate :validate_content_lenght
  validate :validate_content_attached_files_byte_size

  MAX_CONTENT_LENGHT = 50
  MAX_TOTALL_BYTE_ATTACHED_FILES = 3.megabytes

  def attached_files
    content.body.attachables.grep(ActiveStorage::Blob).uniq
  end

  def totall_byte_attached_files
    attached_files.inject(0) do |sum, attached_file|
      sum + attached_file.byte_size
    end
  end

  private

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

  def validate_content_attached_files_byte_size
    return if totall_byte_attached_files < MAX_TOTALL_BYTE_ATTACHED_FILES

    errors.add(
      :base,
      :content_attached_files_byte_size_is_too_large,
      max_totall_byte_attached_files: MAX_TOTALL_BYTE_ATTACHED_FILES,
      totall_byte: totall_byte
    )
  end
end
