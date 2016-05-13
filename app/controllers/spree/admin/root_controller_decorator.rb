Spree::Admin::RootController.class_eval do
  protected

  def admin_root_redirect_path
    if spree_current_user.present? && spree_current_user.designer?
      spree.admin_products_path
    else
      spree.admin_orders_path
    end
  end
end
