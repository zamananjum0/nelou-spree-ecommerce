FactoryGirl.define do
  factory :sale_price, :class => 'Nelou::SalePrice' do
    value 20
    start_at { Date.today }
    end_at { Date.today + 1.month }
    enabled true
  end

end
