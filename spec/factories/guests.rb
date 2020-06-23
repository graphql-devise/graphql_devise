# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    email    { Faker::Internet.unique.email }
    password { Faker::Internet.password }

    trait :confirmed do
      confirmed_at { Time.now }
    end
  end
end
