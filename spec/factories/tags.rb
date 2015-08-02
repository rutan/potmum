FactoryGirl.define do
  factory :tag do
    content { Faker::Name.first_name }
    article_count 0
    is_menu false
  end
end
