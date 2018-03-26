# frozen_string_literal: true

Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :email, !types.String

  field :job do
    argument :id, !types.ID
    type Types::ClassificationJobType
    resolve(lambda do |_obj, args, _c|
      # TODO: auth
      ClassificationJob.find(args[:id])
    end)
  end

  field :classifier do
    argument :id, !types.ID
    type Types::ClassifierType
    resolve(lambda do |_obj, args, ctx|
      Classifier.find_by(organization_id: ctx[:current_user].organization_id,
                         id: args[:id])
    end)
  end

  field :jobs do
    type types[Types::ClassificationJobType]
    resolve(lambda do |obj, _args, _c|
      obj.jobs.order(created_at: :desc)
    end)
  end

  field :classifiers do
    type types[Types::ClassifierType]
    resolve(lambda do |obj, _args, _c|
      obj.classifiers
    end)
  end

  field :output_assets do
    type types[Types::OutputAssetType]
    description "get all the cohorts!"
    resolve(lambda do |obj, _args, _ctx|
      obj.output_assets
    end)
  end
end
