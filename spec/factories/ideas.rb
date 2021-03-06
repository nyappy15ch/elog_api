FactoryBot.define do
  factory :idea do
    association :category
    body { 'これはテストです' }
  end
end
