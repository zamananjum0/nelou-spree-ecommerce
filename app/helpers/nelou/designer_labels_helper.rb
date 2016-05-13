module Nelou::DesignerLabelsHelper
  def designer_country_name(designer_label)
    if designer_label.present? && designer_label.country.present?
      country = ISO3166::Country.find_country_by_alpha2 designer_label.country
      if country.present?
        country.translation(I18n.locale)
      end
    end
  end
end
