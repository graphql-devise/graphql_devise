# frozen_string_literal: true

class AddAuthAvailableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :auth_available, :boolean, null: false, default: true
  end
end
