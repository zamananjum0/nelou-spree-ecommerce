Spree::PrintInvoice::Config.set(logo_path: Rails.root.join('app', 'assets', 'images', 'logo_invoice.png'))
Spree::PrintInvoice::Config.set(font_face: 'Helvetica') # TODO: Figure out to add Futura font family
Spree::PrintInvoice::Config.set(print_buttons: 'invoice')

if Spree::PrintInvoice::Config[:next_number].nil? || Spree::PrintInvoice::Config[:next_number] < 100_012
  Spree::PrintInvoice::Config.set(next_number: 100_012)
end
