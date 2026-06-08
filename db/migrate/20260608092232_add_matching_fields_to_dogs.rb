class AddMatchingFieldsToDogs < ActiveRecord::Migration[8.1]
  def change
    add_column :dogs, :size, :string
    add_column :dogs, :energy_level, :string
    add_column :dogs, :canine_sociability, :string
    add_column :dogs, :human_sociability, :string
    add_column :dogs, :temperament, :string
    add_column :dogs, :favorite_activity, :string
  end
end
