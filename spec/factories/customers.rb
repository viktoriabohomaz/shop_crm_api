FactoryBot.define do
  factory :customer do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    created_by { create(:user) }
    updated_by { create(:user) }
  end
end
