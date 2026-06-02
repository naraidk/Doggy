class CreateWoufs < ActiveRecord::Migration[8.1]
  def change
    create_table :woufs do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
