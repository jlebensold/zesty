# frozen_string_literal: true

require "zip"
module Api
  class InputJobAssetsController < BaseController
    def show
      job = ClassificationJob.find(params[:id])
      zipfile_name = Tempfile.new(["job", ".zip"], Rails.root.join("tmp"))
      Zip::File.open(zipfile_name.path, Zip::File::CREATE) do |zipfile|
        files = []
        job.classifier.asset_labels.each do |label|
          job.classifier.input_assets.where(label: label).each_with_index do |asset, _index|
            copy_path = Tempfile.new("file", Rails.root.join("tmp"))
            copy_path.binmode
            logger.info "Saving #{copy_path}"
            asset.copy_to_local_file(copy_path)
            if File.exist? copy_path
              zipfile.add("#{label}/#{asset.id}_#{asset.attachment.original_filename}", copy_path)
            end
          end
        end
      end
      job.update_attributes(status: :started)
      send_file zipfile_name,
                type: "application/zip",
                disposition: "attachment",
                url_based_filename: true
    end
  end
end
