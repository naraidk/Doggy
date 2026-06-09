class CreateSwipes < ActiveRecord::Migration[8.1]
  def change
    create_table :swipes do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :target_dog, null: false, foreign_key: { to_table: :dogs }
      t.boolean :liked

      t.timestamps
    end
  end
end
