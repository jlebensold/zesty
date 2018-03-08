# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  before_perform do |_job|
    @logger_tempfile = Tempfile.new(["job", ".log"])
    logger = Logger.new(@logger_tempfile.path)
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @job_logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
