module Nelou
  module Product
    module LimitedItems
      extend ActiveSupport::Concern

      def limited?
        variants.where(limited: true).any?
      end

      def limited_items
        variants.map(&:limited_items).reject(&:nil?).sum
      end

      def limited_items_sold
        variants.map(&:limited_items_sold).reject(&:nil?).sum
      end

      def limited_items_available
        limited_items - limited_items_sold
      end

      def not_in_stock?
        !available? || (limited? && (limited_items_available <= 0))
      end

      def in_stock?
        !not_in_stock?
      end
    end
  end
end
