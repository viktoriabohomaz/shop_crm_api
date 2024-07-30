FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    is_admin { false }

    trait :admin do
      admin { true }
    end
  end
end
