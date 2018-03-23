Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :email, !types.String

  field :jobs do
    type types[Types::ClassificationJobType]
    resolve(lambda do |obj, args, _c|
      obj.jobs
    end)
  end

  field :classifiers do
    type types[Types::ClassifierType]
    resolve(lambda do |obj, args, _c|
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
