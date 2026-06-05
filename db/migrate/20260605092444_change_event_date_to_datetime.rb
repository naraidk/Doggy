class ChangeEventDateToDatetime < ActiveRecord::Migration[8.1]
  def change
    change_column :events, :date, :datetime
  end
end
