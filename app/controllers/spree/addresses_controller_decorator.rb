Spree::AddressesController.class_eval do
  private

  def address_params
    params[:address].permit(:address,
                            :firstname,
                            :lastname,
                            :address1,
                            :address2,
                            :city,
                            :state_id,
                            :zipcode,
                            :country_id,
                            :phone,
                            :gender
                           )
  end
end
