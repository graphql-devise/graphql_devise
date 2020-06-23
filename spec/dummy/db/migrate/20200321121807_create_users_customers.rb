# frozen_string_literal: true

class CreateUsersCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :users_customers do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ''

      ## User Info
      t.string :email

      ## Tokens
      t.text :tokens

      t.string :name, null: false

      t.timestamps
    end
  end
end
