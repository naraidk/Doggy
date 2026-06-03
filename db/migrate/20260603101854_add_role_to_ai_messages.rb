class AddRoleToAiMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :ai_messages, :role, :string
  end
end
