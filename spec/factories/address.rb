# Caught for now, no idea why this leads into an dependency hell

require 'spree/testing_support/factories'

begin
  FactoryGirl.modify do

    factory :address do
      gender { %w(m f).sample }
    end

  end

rescue => e
end
