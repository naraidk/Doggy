class AddDogToMessages < ActiveRecord::Migration[8.1]
  def change
    add_reference :messages, :dog, null: false, foreign_key: true
  end
end
