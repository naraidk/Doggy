require 'open-uri'
require 'json'

puts "Cleaning database..."
Swipe.destroy_all
AiMessage.destroy_all
AiChat.destroy_all
Message.destroy_all
Conversation.destroy_all
Comment.destroy_all
Wouf.destroy_all
Post.destroy_all
EventParticipant.destroy_all
Event.destroy_all
Dog.destroy_all
User.destroy_all

# ─── Helper ────────────────────────────────────────────────────────────────────

def attach_avatar(dog, breed_path)
  api_url = "https://dog.ceo/api/breed/#{breed_path}/images/random"
  image_url = JSON.parse(URI.open(api_url).read)['message']
  ext = File.extname(URI.parse(image_url).path).delete('.').downcase
  ext = 'jpg' if ext.empty?
  content_type = ext == 'png' ? 'image/png' : 'image/jpeg'
  dog.avatar.attach(
    io: URI.open(image_url),
    filename: "#{dog.name.parameterize}.#{ext}",
    content_type: content_type
  )
  puts "    📷  Avatar attached for #{dog.name}"
rescue => e
  puts "    ⚠️   Could not attach avatar for #{dog.name}: #{e.message}"
end

def attach_post_image(post, breed_path)
  api_url = "https://dog.ceo/api/breed/#{breed_path}/images/random"
  image_url = JSON.parse(URI.open(api_url).read)['message']
  ext = File.extname(URI.parse(image_url).path).delete('.').downcase
  ext = 'jpg' if ext.empty?
  content_type = ext == 'png' ? 'image/png' : 'image/jpeg'
  post.image.attach(
    io: URI.open(image_url),
    filename: "post_#{post.id}.#{ext}",
    content_type: content_type
  )
  puts "    🖼️   Image attached to post by #{post.dog.name}"
rescue => e
  puts "    ⚠️   Could not attach image to post: #{e.message}"
end

# ─── Users ─────────────────────────────────────────────────────────────────────

puts "\nCreating users..."

users_data = [
  { first_name: "Antoine",  last_name: "Dubois",   email: "an_d@email.com" },
  { first_name: "Mathieu",  last_name: "Leroy",    email: "ma_l@email.com" },
  { first_name: "Nicolas",  last_name: "Martin",   email: "ni_m@email.com" },
  { first_name: "Thomas",   last_name: "Bernard",  email: "th_b@email.com" },
  { first_name: "Julien",   last_name: "Moreau",   email: "ju_m@email.com" },
  { first_name: "Sophie",   last_name: "Lefebvre", email: "so_l@email.com" },
  { first_name: "Camille",  last_name: "Dupont",   email: "ca_d@email.com" },
  { first_name: "Léa",      last_name: "Rousseau", email: "le_r@email.com" },
  { first_name: "Marie",    last_name: "Petit",    email: "ma_p@email.com" },
  { first_name: "Emma",     last_name: "Girard",   email: "em_g@email.com" },
]

users = users_data.map do |d|
  u = User.create!(
    first_name: d[:first_name],
    last_name:  d[:last_name],
    email:      d[:email],
    username:   d[:email].split('@').first,
    password:   "password",
    password_confirmation: "password"
  )
  puts "  ✅  #{u.first_name} #{u.last_name} — #{u.email}"
  u
end

antoine, mathieu, nicolas, thomas, julien,
sophie, camille, lea, marie, emma = users

# ─── Dogs ──────────────────────────────────────────────────────────────────────

puts "\nCreating dogs..."

dogs_data = [
  # Antoine — 1 dog
  {
    user: antoine,
    name: "Filou", breed: "Jack Russell Terrier", age: 3, gender: "Mâle",
    description: "Filou est un petit diable plein d'énergie qui adore courir dans tous les sens. Il est toujours prêt pour une nouvelle aventure et fait rire tout le monde !",
    size: "Petit", energy_level: "Très dynamique", canine_sociability: "Très sociable",
    human_sociability: "Adore les humains", temperament: "Joueur", favorite_activity: "Course",
    breed_path: "terrier/russell"
  },
  # Mathieu — 1 dog
  {
    user: mathieu,
    name: "Luna", breed: "Berger Américain", age: 2, gender: "Femelle",
    description: "Luna est une belle berger américaine aux yeux bleus envoûtants. Elle est très intelligente et adore apprendre de nouveaux tours chaque semaine.",
    size: "Grand", energy_level: "Dynamique", canine_sociability: "Sociable",
    human_sociability: "Très affectueux", temperament: "Aventurier", favorite_activity: "Randonnée",
    breed_path: "australian/shepherd"
  },
  # Nicolas — 1 dog
  {
    user: nicolas,
    name: "César", breed: "Golden Retriever", age: 4, gender: "Mâle",
    description: "César est le golden retriever parfait — doux, affectueux et toujours souriant. Il ne refuse jamais une partie de balle ni un bon câlin après la balade.",
    size: "Grand", energy_level: "Équilibré", canine_sociability: "Adore tous les chiens",
    human_sociability: "Adore les humains", temperament: "Affectueux", favorite_activity: "Jeux",
    breed_path: "retriever/golden"
  },
  # Thomas — 1 dog
  {
    user: thomas,
    name: "Rocky", breed: "Bouledogue Français", age: 5, gender: "Mâle",
    description: "Rocky est un bouledogue français au caractère bien trempé. Malgré son air sérieux, il est très câlin avec ceux qu'il aime et ronronne presque comme un chat.",
    size: "Petit", energy_level: "Calme", canine_sociability: "Sélectif",
    human_sociability: "Amical", temperament: "Protecteur", favorite_activity: "Promenade tranquille",
    breed_path: "bulldog/french"
  },
  # Julien — 1 dog
  {
    user: julien,
    name: "Rex", breed: "Labrador", age: 1, gender: "Mâle",
    description: "Rex est encore un chiot mais déjà un grand gaillard plein d'amour ! Il est curieux de tout, déborde d'énergie et veut devenir ami avec tout le monde.",
    size: "Grand", energy_level: "Très dynamique", canine_sociability: "Adore tous les chiens",
    human_sociability: "Adore les humains", temperament: "Joueur", favorite_activity: "Baignade",
    breed_path: "labrador"
  },
  # Sophie — 1 dog
  {
    user: sophie,
    name: "Coco", breed: "Jack Russell Terrier", age: 6, gender: "Femelle",
    description: "Coco est une jack russell pleine de caractère. Petite mais intrépide, elle n'a peur de rien et peut explorer pendant des heures sans jamais se fatiguer.",
    size: "Petit", energy_level: "Dynamique", canine_sociability: "Sociable",
    human_sociability: "Amical", temperament: "Aventurier", favorite_activity: "Course",
    breed_path: "terrier/russell"
  },
  # Camille — 1 dog
  {
    user: camille,
    name: "Princesse", breed: "Caniche", age: 7, gender: "Femelle",
    description: "Princesse mérite bien son nom ! Cette caniche élégante adore être chouchoutée mais sait aussi être espiègle quand bon lui semble. Elle adore les câlins.",
    size: "Petit", energy_level: "Calme", canine_sociability: "Sélectif",
    human_sociability: "Très affectueux", temperament: "Affectueux", favorite_activity: "Promenade tranquille",
    breed_path: "poodle"
  },
  # Léa — 1 dog
  {
    user: lea,
    name: "Simba", breed: "Berger Américain", age: 3, gender: "Mâle",
    description: "Simba est un berger américain merle tricolore magnifique. Athlétique et vif, il excelle dans les sports canins et adore les longues randonnées en montagne.",
    size: "Grand", energy_level: "Très dynamique", canine_sociability: "Très sociable",
    human_sociability: "Amical", temperament: "Joueur", favorite_activity: "Randonnée",
    breed_path: "australian/shepherd"
  },
  # Marie — 2 dogs
  {
    user: marie,
    name: "Bella", breed: "Golden Retriever", age: 2, gender: "Femelle",
    description: "Bella est une golden retriever douce et lumineuse. Elle adore les enfants, les autres chiens et surtout les balades au bord de l'eau les weekends.",
    size: "Grand", energy_level: "Équilibré", canine_sociability: "Adore tous les chiens",
    human_sociability: "Adore les humains", temperament: "Affectueux", favorite_activity: "Jeux",
    breed_path: "retriever/golden"
  },
  {
    user: marie,
    name: "Gribouille", breed: "Bouledogue Français", age: 4, gender: "Femelle",
    description: "Gribouille est une bouledogue française adorable avec sa petite tête ronde. Elle est gourmande et câline, toujours collée à sa maîtresse sur le canapé.",
    size: "Petit", energy_level: "Calme", canine_sociability: "Sociable",
    human_sociability: "Très affectueux", temperament: "Affectueux", favorite_activity: "Promenade tranquille",
    breed_path: "bulldog/french"
  },
  # Emma — 3 dogs
  {
    user: emma,
    name: "Titi", breed: "Jack Russell Terrier", age: 2, gender: "Mâle",
    description: "Titi est un jack russell terrier espiègle et malin. Il a toujours un tour dans son sac, fait des bêtises et arrive quand même à se faire pardonner instantanément.",
    size: "Petit", energy_level: "Très dynamique", canine_sociability: "Très sociable",
    human_sociability: "Adore les humains", temperament: "Joueur", favorite_activity: "Jeux",
    breed_path: "terrier/russell"
  },
  {
    user: emma,
    name: "Chocolat", breed: "Labrador", age: 5, gender: "Femelle",
    description: "Chocolat est une labrador chocolat au pelage soyeux comme de la soie. Douce et obéissante, elle est le compagnon idéal pour les longues balades en famille.",
    size: "Grand", energy_level: "Équilibré", canine_sociability: "Adore tous les chiens",
    human_sociability: "Adore les humains", temperament: "Affectueux", favorite_activity: "Baignade",
    breed_path: "labrador"
  },
  {
    user: emma,
    name: "Dakota", breed: "Berger Américain", age: 1, gender: "Femelle",
    description: "Dakota est encore une jeune chienne pleine de promesses. Curieuse et vive, elle apprend très vite et adore les nouvelles découvertes lors de ses promenades.",
    size: "Grand", energy_level: "Dynamique", canine_sociability: "Sociable",
    human_sociability: "Amical", temperament: "Aventurier", favorite_activity: "Course",
    breed_path: "australian/shepherd"
  },
]

dogs = dogs_data.map do |d|
  dog = Dog.create!(
    user:               d[:user],
    name:               d[:name],
    breed:              d[:breed],
    age:                d[:age],
    gender:             d[:gender],
    description:        d[:description],
    size:               d[:size],
    energy_level:       d[:energy_level],
    canine_sociability: d[:canine_sociability],
    human_sociability:  d[:human_sociability],
    temperament:        d[:temperament],
    favorite_activity:  d[:favorite_activity]
  )
  puts "  🐶  #{dog.name} (#{dog.breed}) — #{d[:user].first_name}"
  attach_avatar(dog, d[:breed_path])
  dog
end

filou, luna, cesar, rocky, rex,
coco, princesse, simba, bella, gribouille,
titi, chocolat, dakota = dogs

# ─── Posts ─────────────────────────────────────────────────────────────────────

puts "\nCreating posts..."

posts_data = [
  {
    dog: filou,
    content: "Filou a découvert un écureuil aujourd'hui dans le parc de la Villette. La chasse était intense... l'écureuil a gagné 😅 Mais on reviendra demain !"
  },
  {
    dog: luna,
    content: "Luna vient de passer son niveau 1 d'agility ce matin ! Tellement fière de ma belle berger 🌟 On s'entraîne depuis 3 mois et le travail paie enfin !"
  },
  {
    dog: cesar,
    content: "Dimanche au parc avec César ☀️ Une heure de balle et tout le monde est heureux dans la vie. Les golden retrievers, c'est vraiment le bonheur en pelage doré 🐾"
  },
  {
    dog: rocky,
    content: "Rocky fait sa sieste royale sur le canapé. Le canapé, c'est son territoire maintenant. On a négocié... j'ai perdu. Il daigne me laisser le coin droit 👑"
  },
  {
    dog: rex,
    content: "Premier bain de mer pour Rex à Arcachon ! Il est complètement fou de l'eau, impossible de le faire sortir 🌊 On a failli rentrer sans lui tellement il adorait ça !"
  },
  {
    dog: coco,
    content: "Coco a encore trouvé un trou dans la clôture du jardin. L'ingéniosité de cette petite me sidère à chaque fois. Mission : colmater la brèche avant demain matin 🐾"
  },
  {
    dog: princesse,
    content: "Retour du salon de toilettage pour ma Princesse ✨ Elle le sait qu'elle est belle, croyez-moi... Elle se regarde dans chaque vitrine depuis ce matin 💅"
  },
]

posts = posts_data.map do |d|
  post = Post.create!(dog: d[:dog], content: d[:content])
  puts "  📝  Post by #{d[:dog].name}"
  post
end

post_filou, post_luna, post_cesar, post_rocky,
post_rex, post_coco, post_princesse = posts

puts "\nAttaching post images..."
attach_post_image(post_luna,     "australian/shepherd")
attach_post_image(post_cesar,    "retriever/golden")
attach_post_image(post_rex,      "labrador")
attach_post_image(post_princesse, "poodle")

# ─── Woufs ─────────────────────────────────────────────────────────────────────

puts "\nCreating woufs..."

woufs_data = [
  { dog: luna,       post: post_filou },
  { dog: cesar,      post: post_filou },
  { dog: simba,      post: post_filou },
  { dog: filou,      post: post_luna },
  { dog: bella,      post: post_luna },
  { dog: dakota,     post: post_luna },
  { dog: rex,        post: post_cesar },
  { dog: chocolat,   post: post_cesar },
  { dog: princesse,  post: post_cesar },
  { dog: luna,       post: post_rocky },
  { dog: princesse,  post: post_rocky },
  { dog: coco,       post: post_rocky },
  { dog: cesar,      post: post_rex },
  { dog: simba,      post: post_rex },
  { dog: titi,       post: post_rex },
  { dog: titi,       post: post_coco },
  { dog: filou,      post: post_coco },
  { dog: rex,        post: post_coco },
  { dog: bella,      post: post_princesse },
  { dog: gribouille, post: post_princesse },
  { dog: coco,       post: post_princesse },
]

woufs_data.each { |d| Wouf.create!(dog: d[:dog], post: d[:post]) }
puts "  ✅  #{Wouf.count} woufs created"

# ─── Comments ──────────────────────────────────────────────────────────────────

puts "\nCreating comments..."

comments_data = [
  { dog: luna,       post: post_filou,     content: "Haha trop drôle ! Filou le chasseur 😂 L'écureuil n'avait qu'à pas être aussi rapide !" },
  { dog: cesar,      post: post_filou,     content: "Un jour tu l'auras Filou ! J'y crois pour toi 🐾💪" },
  { dog: filou,      post: post_luna,      content: "BRAVO LUNA ! 🎉 Tu mérites tellement cette récompense, vous bossez dur tous les deux !" },
  { dog: rocky,      post: post_luna,      content: "Impressionnant ! Moi j'aurais dormi pendant les obstacles 😴" },
  { dog: simba,      post: post_luna,      content: "Les bergers américains on est les meilleurs en agility, c'est bien connu 🏆" },
  { dog: rex,        post: post_cesar,     content: "Les goldens c'est la meilleure race du monde, j'en suis convaincu 💛" },
  { dog: coco,       post: post_cesar,     content: "César t'as l'air tellement heureux ! Gardez-nous une place au parc 🌿" },
  { dog: luna,       post: post_rocky,     content: "Rocky le roi du canapé 👑 Respect total pour cette attitude assumée !" },
  { dog: princesse,  post: post_rocky,     content: "Je comprends Rocky, le canapé c'est sacré. Solidarité canine 🛋️" },
  { dog: cesar,      post: post_rex,       content: "L'eau c'est la VIE ! Bienvenue dans le club des nageurs Rex 🏊‍♂️🐾" },
  { dog: simba,      post: post_rex,       content: "La tête qu'il a dans l'eau c'est trop beau 😂 Quel bonheur !" },
  { dog: titi,       post: post_coco,      content: "Coco et moi on devrait monter une entreprise de tunnels canins 😂 Je la comprends tellement !" },
  { dog: filou,      post: post_coco,      content: "Respect Coco 🫡 Nous les jack russells on est ingénieux par nature, c'est dans notre ADN !" },
  { dog: bella,      post: post_princesse, content: "Elle est trop belle Princesse ! Cette coupe est parfaite ✨😍" },
  { dog: gribouille, post: post_princesse, content: "Moi aussi je veux aller au toilettage maintenant 😢 Tu me passes l'adresse du salon ?" },
]

comments_data.each { |d| Comment.create!(dog: d[:dog], post: d[:post], content: d[:content]) }
puts "  ✅  #{Comment.count} comments created"

# ─── Events ────────────────────────────────────────────────────────────────────

puts "\nCreating events..."

events_data = [
  {
    dog: filou,
    title: "La Grande Promenade des Saucisses",
    description: "La promenade incontournable des teckels et petits gabarits ! Rejoignez-nous pour une balade friendly au Champ de Mars. Toutes les races sont les bienvenues, venez nombreux avec vos petits boudins à quatre pattes 🌭🐾",
    city: "Paris, Champ de Mars",
    date: Time.now + 10.days,
    latitude: 48.8556, longitude: 2.2986
  },
  {
    dog: cesar,
    title: "Apéro Chien Friendly à Montmartre",
    description: "Une belle terrasse dog friendly à Montmartre pour partager un verre entre humains et laisser nos chiens faire connaissance. Ambiance décontractée garantie, les chiens sont les vrais VIP de la soirée 🍷🐶",
    city: "Paris, Montmartre",
    date: Time.now + 7.days,
    latitude: 48.8867, longitude: 2.3431
  },
  {
    dog: luna,
    title: "Baignade Collective au Bois de Boulogne",
    description: "On se retrouve au lac du Bois de Boulogne pour une grande session de baignade canine ! Amenez serviettes, friandises et bonne humeur. C'est la fête à la flotte 🌊🐕",
    city: "Paris, Bois de Boulogne",
    date: Time.now + 14.days,
    latitude: 48.8636, longitude: 2.2461
  },
  {
    dog: rex,
    title: "Randonnée en Forêt de Fontainebleau",
    description: "Grande randonnée de 12km en forêt de Fontainebleau pour chiens sportifs et leurs humains. Terrain varié, rochers, sentiers forestiers. Prévoir eau et croquettes pour une pause en chemin 🌲🥾",
    city: "Fontainebleau, Seine-et-Marne",
    date: Time.now + 21.days,
    latitude: 48.4078, longitude: 2.7019
  },
  {
    dog: bella,
    title: "Pique-nique Canin sur la Promenade des Anglais",
    description: "Pique-nique géant entre chiens et maîtres sur la Promenade des Anglais à Nice ! Vue sur la mer, soleil et bonne compagnie garantis. Chacun amène quelque chose à partager 🥐🌞🐾",
    city: "Nice, Promenade des Anglais",
    date: Time.now + 18.days,
    latitude: 43.6961, longitude: 7.2662
  },
]

events = events_data.map do |d|
  event = Event.new(
    dog:         d[:dog],
    title:       d[:title],
    description: d[:description],
    city:        d[:city],
    date:        d[:date],
    latitude:    d[:latitude],
    longitude:   d[:longitude]
  )
  event.save!(validate: false)
  puts "  📅  #{event.title} — #{event.city}"
  event
end

# ─── Event participants ─────────────────────────────────────────────────────────

puts "\nCreating event participants..."

[
  { event: events[0], dog: rocky },
  { event: events[0], dog: coco },
  { event: events[0], dog: titi },
  { event: events[1], dog: simba },
  { event: events[1], dog: bella },
  { event: events[1], dog: princesse },
  { event: events[2], dog: chocolat },
  { event: events[2], dog: rex },
  { event: events[3], dog: luna },
  { event: events[3], dog: simba },
  { event: events[3], dog: dakota },
  { event: events[4], dog: coco },
  { event: events[4], dog: gribouille },
].each { |d| EventParticipant.create!(event: d[:event], dog: d[:dog]) }

puts "  ✅  #{EventParticipant.count} participants created"

# ─── Randomize feed timestamps ─────────────────────────────────────────────────

puts "\nRandomizing feed timestamps..."

all_feed_items = posts + events
all_feed_items.each do |item|
  t = rand(14.days.ago..6.hours.ago)
  item.update_columns(created_at: t, updated_at: t)
end
puts "  ✅  Timestamps randomized for #{all_feed_items.count} items"

# ─── Summary ───────────────────────────────────────────────────────────────────

puts "\n✅  Seeding complete!"
puts "   #{User.count} users"
puts "   #{Dog.count} dogs"
puts "   #{Post.count} posts"
puts "   #{Wouf.count} woufs"
puts "   #{Comment.count} comments"
puts "   #{Event.count} events"
puts "   #{EventParticipant.count} event participants"
puts "\n   All passwords: password"
puts "   Emails: an_d, ma_l, ni_m, th_b, ju_m, so_l, ca_d, le_r, ma_p, em_g — all @email.com"
