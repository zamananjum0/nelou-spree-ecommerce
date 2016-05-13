module Nelou
  module Product
    module OptionFilters
      extend ActiveSupport::Concern

      included do
        scope :option_any, -> (opts) { joins(:variants_including_master => :option_values).where("#{Spree::OptionValue.quoted_table_name}.id": opts) }
      end
    end
  end
end
