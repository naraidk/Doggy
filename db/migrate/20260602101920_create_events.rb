class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :dog, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :city
      t.date :date

      t.timestamps
    end
  end
end
