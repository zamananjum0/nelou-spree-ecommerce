Spree::Image.class_eval do
  include Nelou::HasCustomFileName
  include Nelou::AttachmentFromUrl

  allow_from_url :attachment

  has_custom_file_name :attachment, :generate_hex_for_file_name
end
