Spree::Admin::ProductsController.class_eval do

  before_action :load_designer_label_data, except: :index
  before_action :set_designer_label, only: [:create, :update]

  protected

  # Add filter for designer products
  # Unfortunately, `super` does not work here, hence alias_method
  alias_method :orig_collection, :collection
  def collection
    if spree_current_user.designer?
      orig_collection.by_designer(spree_current_user.designer_label)
    else
      orig_collection
    end
  end

  def load_designer_label_data
    @designer_labels = Nelou::DesignerLabel.all.order(:name)
  end

  def set_designer_label
    if spree_current_user.designer?
      params[:product][:designer_label_id] = spree_current_user.designer_label.id
    end
  end

end
