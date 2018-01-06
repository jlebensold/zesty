class ClassifyJob < ApplicationJob
  queue_as :default

  def perform(classifier_id)
    p "FOOBAR #{classifier_id}"
    # Do something later
  end
end
