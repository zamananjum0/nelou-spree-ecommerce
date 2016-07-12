Spree::Address.class_eval do

  validates :gender, inclusion: { in: %w(m f) }, presence: true

  def self.build_default
    new
  end

  def require_phone?
    false
  end

  def name
    [firstname, lastname].reject(&:nil?).reject(&:empty?).join ' '
  end

  def male?
    gender == 'm'
  end

  def female?
    gender == 'f'
  end

end
