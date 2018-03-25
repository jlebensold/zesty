# frozen_string_literal: true

class Resolvers::RunBuild < GraphQL::Function
  description "Run Build"
  argument :classifierId, !types.ID

  type Types::ClassificationJobType

  def call(_o, args, ctx)
    classifier = Classifier.find_by(
      id: args[:classifierId],
      organization_id: ctx[:current_user].organization_id
    )

    job = ClassificationJob.create!(classifier: classifier, status: :queued,
                                    job_number: (classifier.classification_jobs.count + 1))
    ClassifyJob.perform_later job.id
    job
  end
end
