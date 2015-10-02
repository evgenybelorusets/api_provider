FactoryGirl.define do
  factory :user do
    sequence :first_name do |n|
      "John#{n}"
    end

    sequence :last_name do |n|
      "Snow#{n}"
    end

    sequence :email do |n|
      "j.snow#{n}@gmail.com"
    end

    role 1
    uid SecureRandom.hex(16)
  end
end