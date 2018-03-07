# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base

  before_perform do |job|
    @logger_tempfile = Tempfile.new(["job", ".log"])
    logger = Logger.new(@logger_tempfile.path)
    # logger.formatter = ActiveSupport::Logger::Formatter.new
    logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    @job_logger = ActiveSupport::TaggedLogging.new(logger)
  end
end
