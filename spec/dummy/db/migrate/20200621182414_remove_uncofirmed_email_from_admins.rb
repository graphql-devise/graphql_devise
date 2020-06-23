# frozen_string_literal: true

class RemoveUncofirmedEmailFromAdmins < ActiveRecord::Migration[6.0]
  def change
    remove_column :admins, :unconfirmed_email, :string
  end
end
