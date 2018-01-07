# frozen_string_literal: true

Paperclip.options[:content_type_mappings] = {
  mlmodel: ["application/octet-stream"],
  pb: ["application/octet-stream"]
}
