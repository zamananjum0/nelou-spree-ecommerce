Spree::Product.class_eval do
  PRODUCTION_TYPES = %w(ready_to_wear on_demand custom_made)

  belongs_to :designer_label, class_name: 'Nelou::DesignerLabel'

  validates :designer_label, presence: true, on: :create
  validates :production_type, presence: true, inclusion: { in: PRODUCTION_TYPES }

  scope :by_designer, -> (designer_label) { where(designer_label_id: designer_label.id) }
  scope :recent, -> { where('available_on >= ?', 50.days.ago) }
  scope :limited, -> { includes(:variants).where("#{Spree::Variant.quoted_table_name}.limited": true) }
  scope :on_sale, -> { joins(variants: [prices: :sale_prices]).merge(Nelou::SalePrice.active) }
  scope :eco, -> { where(eco: true) }

  scope :descend_by_available_on, -> { order(available_on: :desc) }
  scope :ascend_by_available_on, -> { order(available_on: :asc) }

  include Nelou::Product::LimitedItems
  include Nelou::Product::Sales
  include Nelou::Product::OptionFilters

  # attr_accessor :sale_price, :original_price

  self.whitelisted_ransackable_associations = %w[stores variants_including_master master variants designer_label]
  self.whitelisted_ransackable_attributes = %w[description name slug designer_label_id]

  def recent_from_same_designer
    Spree::Product.active.by_designer(designer_label).order(available_on: :desc)
  end

  def related_in_taxon
    if taxons.present?
      taxons.first.products.active
        .order(available_on: :desc)
        .select("#{Spree::Product.quoted_table_name}.*", '"spree_products_taxons"."position"') # PSQL fails if position is not queried as well
    else
      Spree::Product.active.recent
    end
  end

  def is_by_user?(user)
    user.present? && user.designer? && user.designer_label.present? && user.designer_label.id == designer_label_id
  end

  def is_recent?
    available_on >= 50.days.ago
  end

  def available?
    !(available_on.nil? || available_on.future?) && !deleted? && designer_label.present? && designer_label.active && designer_label.accepted
  end

  # Can't use add_search_scope for this as it needs a default argument
  def self.available(available_on = nil, currency = nil)
    available_on ||= Time.current
    joins(master: :prices)
      .joins(:designer_label)
      .where("#{Nelou::DesignerLabel.quoted_table_name}.active": true, "#{Nelou::DesignerLabel.quoted_table_name}.accepted": true)
      .where("#{Spree::Product.quoted_table_name}.available_on IS NOT NULL")
      .where("#{Spree::Product.quoted_table_name}.available_on <= ?", available_on)
      .uniq
  end

  def slug_candidates
      [
        :name,
        [:name, :id],
        [:name, :id, :sku]
      ]
    end
end
