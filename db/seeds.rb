puts "Cleaning database..."

Swipe.destroy_all if defined?(Swipe)
AiMessage.destroy_all
AiChat.destroy_all
Message.destroy_all
Conversation.destroy_all
Comment.destroy_all
Wouf.destroy_all
Post.destroy_all
EventParticipant.destroy_all if defined?(EventParticipant)
Event.destroy_all if defined?(Event)
Dog.destroy_all
User.destroy_all

puts "Creating users..."

users = []

6.times do |i|
  users << User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    username: "user#{i + 1}",
    first_name: "User#{i + 1}",
    last_name: "Doglover"
  )
end

puts "Creating dogs..."

sizes = ["Petit", "Moyen", "Grand"]
energy_levels = ["Très calme", "Calme", "Équilibré", "Dynamique", "Très dynamique"]
canine_sociabilities = ["Très réservé", "Sélectif", "Sociable", "Très sociable", "Adore tous les chiens"]
human_sociabilities = ["Méfiant", "Réservé", "Amical", "Très affectueux", "Adore les humains"]
temperaments = ["Joueur", "Protecteur", "Aventurier", "Affectueux", "Indépendant"]
favorite_activities = ["Promenade tranquille", "Jeux", "Course", "Randonnée", "Baignade"]

breeds = [
  "Golden Retriever",
  "Husky",
  "Labrador",
  "Berger Allemand",
  "Cocker",
  "Beagle",
  "Border Collie",
  "Shiba Inu",
  "Bulldog",
  "Caniche"
]

dog_names = [
  "Buddy", "Luna", "Max", "Bella", "Rocky",
  "Nala", "Oscar", "Milo", "Ruby", "Simba"
]

users.each_with_index do |user, user_index|
  10.times do |i|
    Dog.create!(
      user: user,
      name: "#{dog_names[i]} #{user_index + 1}",
      breed: breeds[i],
      age: rand(1..12),
      description: "Chien #{temperaments.sample.downcase}, qui aime #{favorite_activities.sample.downcase} et rencontrer de nouveaux compagnons.",
      size: sizes.sample,
      energy_level: energy_levels.sample,
      canine_sociability: canine_sociabilities.sample,
      human_sociability: human_sociabilities.sample,
      temperament: temperaments.sample,
      favorite_activity: favorite_activities.sample
    )
  end
end

puts "Creating sample conversations..."

dog1 = User.first.dogs.first
dog2 = User.second.dogs.first

conversation = Conversation.create!(
  dog_one: dog1,
  dog_two: dog2
)

Message.create!(
  conversation: conversation,
  dog: dog1,
  content: "Wouf ! On fait une balade ?"
)

Message.create!(
  conversation: conversation,
  dog: dog2,
  content: "Oui, avec plaisir !"
)

puts "Creating sample posts..."

post = Post.create!(
  dog: dog1,
  content: "Prêt pour rencontrer de nouveaux amis 🐾"
)

Comment.create!(
  dog: dog2,
  post: post,
  content: "Trop mignon !"
)

Wouf.create!(
  dog: dog2,
  post: post
)

puts "Done!"
puts "#{User.count} users created"
puts "#{Dog.count} dogs created"
puts "#{Swipe.count} swipes created" if defined?(Swipe)
