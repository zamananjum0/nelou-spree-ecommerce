Spree::Order.class_eval do
  has_many :designer_labels, through: :products

  include Nelou::ContainsDesigner

  state_machine.after_transition to: :complete, do: :increment_limited_items_counter

  alias_method :orig_deliver_order_confirmation_email, :deliver_order_confirmation_email

  def deliver_order_confirmation_email
    orig_deliver_order_confirmation_email
    Nelou::DesignerMailer.notification_mails(id)
    Nelou::OrderMailer.notification_mail(id).deliver_later
  end

  # Do not generate random order numbers
  def generate_number(options = {})
    options[:length]  ||= Spree::NumberGenerator::NUMBER_LENGTH
    self.number = "R%0#{options[:length]}i" % (Spree::Order.count + 1)
  end

  def price_from_line_item(line_item)
    line_item.variant.price_in(currency)
  end

  private

  def increment_limited_items_counter
    line_items.each do |line_item|
      variant = line_item.variant
      variant.limited_items_sold += line_item.quantity
      Spree::Variant.update variant.id, limited_items_sold: variant.limited_items_sold
    end
  end
end
