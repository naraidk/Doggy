class AddGenderToDogs < ActiveRecord::Migration[8.1]
  def change
    add_column :dogs, :gender, :string
  end
end
