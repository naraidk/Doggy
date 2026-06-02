class CreateAiMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_messages do |t|
      t.text :content
      t.references :ai_chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
