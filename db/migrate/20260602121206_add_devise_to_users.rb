class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def self.up
    change_table :users do |t|
      # t.string :email,              null: false, default: ""
      t.string :encrypted_password,  null: false, default: ""

      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email

      # t.string   :unlock_token
      # t.integer  :failed_attempts, default: 0, null: false
      # t.datetime :locked_at
    end

    add_index :users, :reset_password_token, unique: true
    # add_index :users, :email, unique: true
  end

  def self.down
    remove_index :users, :reset_password_token
    # remove_index :users, :email

    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
  end
end
