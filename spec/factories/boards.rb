# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :board do
    region_id 1
    route_id 1
    station_id 1
    user_id 1
    hits 1
    title "MyText"
    contents "MyText"
  end
end
