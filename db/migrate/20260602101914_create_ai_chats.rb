class CreateAiChats < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_chats do |t|
      t.references :dog, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
