Spree::OrdersController.class_eval do
  respond_to :pdf, only: :invoice
  before_action :load_order, only: :invoice

  def invoice
    respond_with(@order) do |format|
      format.pdf do
        @order.update_invoice_number!

        send_data @order.pdf_file(pdf_template_name), type: 'application/pdf', disposition: "attachment; filename=#{@order.number}.pdf"
      end
    end
  end

  private

  def load_order
    @order = Spree::Order.includes(line_items: [variant: [:option_values, :images, :product]], bill_address: :state, ship_address: :state).find_by_number!(params[:id])
  end

  def pdf_template_name
    pdf_template_name = params[:template] || 'invoice'
    if !Spree::PrintInvoice::Config.print_templates.include?(pdf_template_name)
      raise Spree::PrintInvoice::UnsupportedTemplateError.new(pdf_template_name)
    end
    pdf_template_name
  end
end
