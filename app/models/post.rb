class Post < ApplicationRecord
  belongs_to :dog
  has_many :comments, dependent: :destroy
  has_many :woufs, dependent: :destroy
  has_one_attached :image

  validate :conent_or_image_present

  private

  def conent_or_image_present
    return unless content.blank? && !image.attached?

    errors.add(:base, "Le post dot contenir du texte ou une image.")
  end
end
