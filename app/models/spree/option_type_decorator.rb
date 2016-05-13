Spree::OptionType.class_eval do

  scope :in_products, -> (products) { joins(:option_values).merge(Spree::OptionValue.in_products(products)) }

  def self.colour
    Spree::OptionType.find_or_create_by(name: 'Colour') do |c|
      c.name = 'Colour'
      c.presentation = 'Colour'
    end
  end

end
