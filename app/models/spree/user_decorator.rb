Spree::User.class_eval do
  include Nelou::Legacy::Login
  include Nelou::Legacy::Password

  has_one :designer_label, class_name: 'Nelou::DesignerLabel', dependent: :destroy, autosave: true, inverse_of: :user
  has_many :products, through: :designer_label

  delegate :firstname, :lastname, :name, :male?, :female?, to: :billing_address, allow_nil: true

  accepts_nested_attributes_for :designer_label
  accepts_nested_attributes_for :bill_address

  before_save :ensure_designer_label_exists
  before_create :set_locale

  scope :designers, -> { includes(:spree_roles).where("#{Spree::Role.quoted_table_name}.name" => 'designer') }

  attr_accessor :terms_and_services, :privacy_and_conditions

  validates :terms_and_services, acceptance: true, on: :create
  validates :privacy_and_conditions, acceptance: true, on: :create

  def designer?
    has_spree_role?('designer')
  end

  # For Mailchimp, which doesn't work with true/false
  def designer_integer
    designer? ? 1 : 0
  end

  def approved?
    designer? && designer_label.present? && designer_label.accepted && designer_label.active
  end

  protected

  def set_locale
    self.locale = I18n.locale unless self.locale.present?
  end

  def ensure_designer_label_exists
    if designer? && designer_label.nil?
      build_designer_label name: email.split('@').first
    end
  end
end
