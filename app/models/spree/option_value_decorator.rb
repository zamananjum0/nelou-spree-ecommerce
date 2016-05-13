Spree::OptionValue.class_eval do

  scope :in_variants, -> (variants) { joins(:variants).where("#{Spree::Variant.quoted_table_name}.id": variants).uniq }
  scope :in_products, -> (products) { joins(:variants).where("#{Spree::Variant.quoted_table_name}.product_id": products).uniq }

end
