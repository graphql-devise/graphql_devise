# frozen_string_literal: true

FactoryBot.define do
  factory :users_customer, class: 'Users::Customer' do
    name      { Faker::FunnyName.two_word_name }
    email     { Faker::Internet.unique.email }
    password  { Faker::Internet.password }
  end
end
