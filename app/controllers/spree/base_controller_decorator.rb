Spree::BaseController.class_eval do
  private

  def set_user_language
    I18n.locale = if params.key?(:locale) && SpreeI18n::Config.supported_locales.include?(params[:locale].to_sym)
                    session[:locale] = params[:locale]
                    params[:locale]
                  elsif session.key?(:locale) && SpreeI18n::Config.supported_locales.include?(session[:locale].to_sym)
                    session[:locale]
                  elsif http_accept_language.compatible_language_from(SpreeI18n::Config.supported_locales).present?
                    http_accept_language.compatible_language_from(SpreeI18n::Config.supported_locales)
                  elsif respond_to?(:config_locale, true) && !config_locale.blank?
                    config_locale
                  else
                    Rails.application.config.i18n.default_locale || I18n.default_locale
                  end
  end
end
