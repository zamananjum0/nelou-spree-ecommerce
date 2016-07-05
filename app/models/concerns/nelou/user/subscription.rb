module Nelou
  module User
    module Subscription

      extend ActiveSupport::Concern

      included do
        after_create  :subscribe
        after_destroy :unsubscribe
      end

      def is_subscribed?
        # TODO: Figure out how to invalidate after subscribe
        Rails.cache.fetch("#{cache_key}/is_subscribed", expires_in: 1.minute) do
          Nelou::SubscriptionService.new.is_subscribed?(email)
        end
      end

      private

      def subscribe
        if subscribed
          # TODO: Use ActiveJob
          Nelou::SubscriptionService.new.subscribe! email, locale, designer?
        end
      rescue
        self.subscribed = false
        self.update_column(:subscribed, false)
      end

      def unsubscribe
        if subscribed
          begin
            Nelou::SubscriptionService.new.unsubscribe! email
          rescue
          end
        end

        self.subscribed = false
        self.update_column(:subscribed, false)
      end

    end
  end
end
