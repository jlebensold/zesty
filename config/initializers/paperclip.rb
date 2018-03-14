# frozen_string_literal: true

Paperclip.options[:content_type_mappings] = {
  mlmodel: ["application/octet-stream"],
  pb: ["application/octet-stream"],
  log: "text/plain"
}



if Rails.env.production?
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
  Paperclip::Attachment.default_options[:url] = ':gcs_domain_url'
  Paperclip::Attachment.default_options[:fog_directory] = ENV['GCS_BUCKET_NAME']
end
