# frozen_string_literal: true

Paperclip.options[:content_type_mappings] = {
  mlmodel: ["application/octet-stream"],
  pb: ["application/octet-stream"],
  log: "text/plain"
}



if Rails.env.production?
	Paperclip::Attachment.default_options[:storage] = :gcs
	Paperclip::Attachment.default_options[:gcs_bucket] = ENV["GCS_BUCKET_NAME"]
	Paperclip::Attachment.default_options[:url] = ":gcs_path_url"
	Paperclip::Attachment.default_options[:path] = ":class/:attachment/:id/:style/:filename"
	Paperclip::Attachment.default_options[:gcs_credentials] = {
			project: ENV["GCS_PROJECT"],
			keyfile: ENV["GCS_KEYFILE"],
	}
end
