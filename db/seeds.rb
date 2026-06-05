puts "Cleaning database..."

AiMessage.destroy_all
AiChat.destroy_all
Message.destroy_all
Conversation.destroy_all
Comment.destroy_all
Wouf.destroy_all
Post.destroy_all
Dog.destroy_all
User.destroy_all

puts "Creating users..."

john = User.create!(
  email: "john@example.com",
  password: "password",
  username: "johnny",
  first_name: "John",
  last_name: "Doe"
)

sarah = User.create!(
  email: "sarah@example.com",
  password: "password",
  username: "sarahdoglover",
  first_name: "Sarah",
  last_name: "Smith"
)

puts "Creating dogs..."

buddy = Dog.create!(
  user: john,
  name: "Buddy",
  breed: "Golden Retriever",
  age: 3,
  description: "Loves beaches and tennis balls"
)

luna = Dog.create!(
  user: sarah,
  name: "Luna",
  breed: "Husky",
  age: 2,
  description: "Professional zoomies champion"
)

puts "Creating conversation..."

conversation = Conversation.create!(
  dog_one: buddy,
  dog_two: luna
)

puts "Creating messages..."

Message.create!(
  conversation: conversation,
  dog: buddy,
  content: "Woof Luna! Want to go to the park?"
)

Message.create!(
  conversation: conversation,
  dog: luna,
  content: "Absolutely! Let's chase some squirrels."
)

puts "Creating posts..."

post = Post.create!(
  dog: buddy,
  content: "Just had the best walk ever! 🐾"
)

Comment.create!(
  dog: luna,
  post: post,
  content: "Looks amazing Buddy! 🐶"
)

Wouf.create!(
  dog: luna,
  post: post
)

puts "Done!"
