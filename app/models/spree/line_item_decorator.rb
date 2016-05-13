Spree::LineItem.class_eval do
  has_one :designer_label, through: :product
end
