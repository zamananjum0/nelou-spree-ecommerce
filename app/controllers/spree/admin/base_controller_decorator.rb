Spree::Admin::BaseController.class_eval do

  # To help with debugging authorization failures
  def redirect_unauthorized_access
    exception = $! # Exception is not given as a parameter, so we use Ruby's $! to fetch the last parameter
    Rails.logger.debug "Access denied on action #{exception.action}, subject: #{exception.subject.inspect}"

    super
  end

end
