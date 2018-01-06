# frozen_string_literal: true

class OutputAsset < ApplicationRecord
  belongs_to :classifier
  belongs_to :classification_job
  has_attached_file :attachment, path: ":rails_root/assets/input/:id/:filename"
  do_not_validate_attachment_file_type :attachment

end
