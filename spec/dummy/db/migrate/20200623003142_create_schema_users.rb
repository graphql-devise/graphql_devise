# frozen_string_literal: true

class CreateSchemaUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :schema_users do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean  :allow_password_change, default: false

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      # Trackable
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :last_sign_in_ip
      t.string   :current_sign_in_ip
      t.integer  :sign_in_count

      ## User Info
      t.string :name
      t.string :email

      ## Tokens
      t.text :tokens

      t.timestamps
    end

    add_index :schema_users, :email,                unique: true
    add_index :schema_users, [:uid, :provider],     unique: true
    add_index :schema_users, :reset_password_token, unique: true
    add_index :schema_users, :confirmation_token,   unique: true
  end
end
