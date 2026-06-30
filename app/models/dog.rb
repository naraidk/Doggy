class Dog < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  has_many :ai_chats, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :woufs, dependent: :destroy
  has_many :swipes, dependent: :destroy
  has_many :received_swipes, class_name: "Swipe", foreign_key: "target_dog_id", dependent: :destroy

  has_many :conversations_as_one, class_name: "Conversation", foreign_key: "dog_one_id", dependent: :destroy
  has_many :conversations_as_two, class_name: "Conversation", foreign_key: "dog_two_id", dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :breed, presence: true
  validates :description, presence: true, length: { minimum: 12, maximum: 300 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 30 }
  validates :user, presence: true

  def compatibility_with(other_dog)
    energy_score = ordered_score(energy_level, other_dog.energy_level, energy_levels)
    canine_score = ordered_score(canine_sociability, other_dog.canine_sociability, canine_sociabilities)
    human_score = ordered_score(human_sociability, other_dog.human_sociability, human_sociabilities)
    size_score_value = ordered_score(size, other_dog.size, sizes)
    temperament_score_value = temperament_score(temperament, other_dog.temperament)
    activity_score_value = activity_score(favorite_activity, other_dog.favorite_activity)

    (
      (0.20 * energy_score) +
      (0.20 * canine_score) +
      (0.20 * temperament_score_value) +
      (0.15 * activity_score_value) +
      (0.20 * size_score_value) +
      (0.05 * human_score)
    ).round
  end

  private

  def ordered_score(value_a, value_b, scale)
    return 0 if value_a.blank? || value_b.blank?

    index_a = scale.index(value_a)
    index_b = scale.index(value_b)

    return 0 if index_a.nil? || index_b.nil?

    difference = (index_a - index_b).abs
    [100 * (1 - (difference / 4.0)), 0].max
  end

  def energy_levels
    ["Très calme", "Calme", "Équilibré", "Dynamique", "Très dynamique"]
  end

  def canine_sociabilities
    ["Très réservé", "Sélectif", "Sociable", "Très sociable", "Adore tous les chiens"]
  end

  def human_sociabilities
    ["Méfiant", "Réservé", "Amical", "Très affectueux", "Adore les humains"]
  end

  def sizes
    ["Petit", "Moyen", "Grand"]
  end

  def temperament_score(val_a, val_b)
    return 0 if val_a.blank? || val_b.blank?
    return 100 if val_a == val_b

    compatible = {
      "Joueur" => ["Aventurier", "Affectueux"],
      "Protecteur" => ["Affectueux", "Indépendant"],
      "Aventurier" => ["Joueur", "Indépendant"],
      "Affectueux" => ["Joueur", "Protecteur"],
      "Indépendant" => ["Protecteur", "Aventurier"]
    }

    compatible[val_a]&.include?(val_b) ? 80 : 40
  end

  def activity_score(val_a, val_b)
    return 0 if val_a.blank? || val_b.blank?
    return 100 if val_a == val_b

    close_activities = {
      "Promenade tranquille" => ["Randonnée"],
      "Jeux" => ["Course", "Baignade"],
      "Course" => ["Jeux", "Randonnée"],
      "Randonnée" => ["Promenade tranquille", "Course"],
      "Baignade" => ["Jeux"]
    }

    close_activities[val_a]&.include?(val_b) ? 50 : 0
  end
end
