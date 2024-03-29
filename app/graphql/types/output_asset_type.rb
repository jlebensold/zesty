# frozen_string_literal: true

Types::OutputAssetType = GraphQL::ObjectType.define do
  name "OutputAsset"
  field :id, !types.ID
  field :label, !types.String
  field :attachment_file_name, !types.String
  field :url do
    type !types.String
    resolve(lambda do |obj, _args, _ctx|
      obj.public_url
    end)
  end

  field :classification_job do
    type types[Types::ClassificationJobType]
    resolve(lambda do |obj, _args, _ctx|
      obj.classification_job
    end)
  end

  field :classifier do
    type Types::ClassifierType
    resolve(lambda do |obj, _args, _ctx|
      obj.classifier
    end)
  end
end
