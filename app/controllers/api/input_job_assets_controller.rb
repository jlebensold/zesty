# frozen_string_literal: true
require 'zip'
module Api
  class InputJobAssetsController < BaseController
    def show
      job = ClassificationJob.find(params[:id])
			zipfile_name = Tempfile.new(['job', '.zip'], Rails.root.join('tmp'))
			Zip::File.open(zipfile_name.path, Zip::File::CREATE) do |zipfile|
        files = []
        job.classifier.asset_labels.each do |label|
          job.classifier.input_assets.where(label: label).each do |asset|
            copy_path = Tempfile.new("file", Rails.root.join('tmp'))
            logger.info "Saving #{copy_path}"
            asset.attachment.copy_to_local_file(:original, copy_path)
            if File.exists? copy_path
              zipfile.add("#{label}/#{asset.attachment.original_filename}", copy_path)
            end
          end
        end
			end
      job.update_attributes(status: :started)
			send_file zipfile_name,
				type: 'application/zip',
				disposition: 'attachment',
				url_based_filename: true
    end
  end
end
