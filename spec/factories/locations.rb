FactoryBot.define do 
  factory :location do
    name { Faker::Lorem.word }
    address { Faker::Address.street_address }
    postcode { Faker::Address.postcode }
    city { Faker::Address.city }
    country { Faker::Address.country }
  end
end