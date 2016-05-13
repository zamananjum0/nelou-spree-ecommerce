module Nelou
  class DesignerLabelsController < Spree::StoreController
    before_action :load_label, only: [ :show ]

    def show
    end

    private

    def load_label
      @designer_label = Nelou::DesignerLabel.active.friendly.find(params[:id])
    end
  end
end
