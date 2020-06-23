# frozen_string_literal: true

FactoryBot.define do
  factory :schema_user do
    name      { Faker::FunnyName.two_word_name }
    email     { Faker::Internet.unique.email }
    password  { Faker::Internet.password }

    trait :confirmed do
      confirmed_at { Time.zone.now }
    end
  end
end
