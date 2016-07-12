module Nelou
  class DesignerLabelsController < Spree::StoreController
    before_action :load_label, only: [ :show ]
    before_action :load_labels, only: [ :index ]

    def index
    end

    def show
    end

    private

    def load_label
      @designer_label = Nelou::DesignerLabel.active.friendly.find(params[:id])
    end

    def load_labels
      @designer_labels = Nelou::DesignerLabel
        .active
        .joins(:products)
        .uniq
    end
  end
end
