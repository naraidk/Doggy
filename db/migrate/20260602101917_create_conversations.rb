class CreateConversations < ActiveRecord::Migration[8.1]
 
  def change
    create_table :conversations do |t|
      t.bigint :dog_one_id, null: false
      t.bigint :dog_two_id, null: false

      t.timestamps
    end

    add_foreign_key :conversations, :dogs, column: :dog_one_id
    add_foreign_key :conversations, :dogs, column: :dog_two_id
    add_index :conversations, [:dog_one_id, :dog_two_id], unique: true
  end
end
