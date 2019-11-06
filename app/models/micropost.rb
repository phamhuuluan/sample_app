class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.models.micropost.valid_content}
  validate  :picture_size

  private

  def picture_size
    if picture.size > Settings.models.micropost.mega_bytes.megabytes
      errors.add :picture, t(".pic_size")
    end
  end
end
