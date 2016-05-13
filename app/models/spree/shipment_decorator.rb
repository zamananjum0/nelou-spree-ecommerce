Spree::Shipment.class_eval do
  has_many :designer_labels, through: :inventory_units

  include Nelou::ContainsDesigner
end
