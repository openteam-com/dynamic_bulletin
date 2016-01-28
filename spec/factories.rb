FactoryGirl.define do
  sequence :title do |n|
    "Категория #{n}"
  end

  factory :category, class: Category do
    title

    trait :with_properties do
      after(:create) do |category|
        5.times { create :property, category: category }
      end
    end

    trait :with_children do
      after(:create) do |category|
        5.times do
          children = create(:category, parent: category)

          5.times do
            create :property, category: children
          end

          sub_children = create :category, parent: children

          5.times do
            create :property, category: sub_children
          end
        end
      end
    end
  end

  factory :property, class: Property do
    category
    title { ("а".."я").to_a.shuffle.take(20).join("") }
  end
end
