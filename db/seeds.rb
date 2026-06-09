require "open-uri"

puts "Cleaning database..."

Wouf.destroy_all if defined?(Wouf)
Comment.destroy_all if defined?(Comment)
Post.destroy_all if defined?(Post)
Swipe.destroy_all if defined?(Swipe)
Message.destroy_all if defined?(Message)
Conversation.destroy_all if defined?(Conversation)
AiMessage.destroy_all if defined?(AiMessage)
AiChat.destroy_all if defined?(AiChat)
EventParticipant.destroy_all if defined?(EventParticipant)
Event.destroy_all if defined?(Event)
Dog.destroy_all
User.destroy_all

users_data = [
  ["Emma", "Martin", "emma"],
  ["Lucas", "Bernard", "lucas"],
  ["Chloé", "Petit", "chloe"],
  ["Nathan", "Durand", "nathan"],
  ["Sarah", "Moreau", "sarah"],
  ["Thomas", "Laurent", "thomas"],
  ["Julie", "Simon", "julie"],
  ["Hugo", "Michel", "hugo"],
  ["Camille", "Lefevre", "camille"],
  ["Alexandre", "Roux", "alexandre"]
]

dogs_data = [
  ["Rex", "Golden Retriever"], ["Bella", "Labrador"],
  ["Max", "Beagle"], ["Luna", "Border Collie"],
  ["Rocky", "Berger Allemand"], ["Milo", "Husky"],
  ["Nala", "Cocker"], ["Simba", "Dalmatien"],
  ["Daisy", "Caniche"], ["Buddy", "Boxer"],
  ["Oscar", "Shiba Inu"], ["Ruby", "Spitz"],
  ["Coco", "Bouledogue Français"], ["Leo", "Akita"],
  ["Maya", "Berger Australien"], ["Jack", "Teckel"],
  ["Lucky", "Bichon"], ["Nova", "Malinois"],
  ["Tina", "Carlin"], ["Ollie", "Corgi"]
]

dog_index = 0

users_data.each do |first_name, last_name, username|
  user = User.create!(
    first_name: first_name,
    last_name: last_name,
    username: username,
    email: "#{username}@doggy.com",
    password: "password123"
  )

  2.times do
    name, breed = dogs_data[dog_index]

    dog = Dog.create!(
      user: user,
      name: name,
      breed: breed,
      gender: ["Male", "Female"].sample,
      age: rand(1..10),
      size: ["Petit", "Moyen", "Grand"].sample,
      energy_level: ["Calme", "Modéré", "Dynamique"].sample,
      canine_sociability: ["Peu sociable", "Sociable", "Très sociable"].sample,
      human_sociability: ["Réservé", "Affectueux", "Très affectueux"].sample,
      temperament: ["Joueur", "Protecteur", "Curieux", "Calme"].sample,
      favorite_activity: ["Jeux", "Course", "Balade", "Natation"].sample,
      description: "#{name} est un chien adorable, sociable et plein de personnalité."
    )

    dog.avatar.attach(
      io: URI.open("https://placedog.net/600/600?id=#{dog_index + 1}"),
      filename: "#{name.downcase}.jpg",
      content_type: "image/jpeg"
    )

    dog_index += 1
  end
end

puts "#{User.count} utilisateurs créés"
puts "#{Dog.count} chiens créés"
puts "Seed terminé !"
