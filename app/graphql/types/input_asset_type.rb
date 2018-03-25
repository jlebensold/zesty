# frozen_string_literal: true

Types::InputAssetType = GraphQL::ObjectType.define do
  name "InputAsset"
  field :id, !types.ID
  field :label, !types.String
  field :attachment_file_name, !types.String
  field :thumbnail_url do
    type !types.String
    resolve(lambda do |obj, _args, _ctx|
      StorageManager.new.thumbnail_url(obj)
    end)
  end

  field :url do
    type !types.String
    resolve(lambda do |obj, _args, _ctx|
      obj.public_url
    end)
  end

  field :classifier do
    type Types::ClassifierType
    resolve(lambda do |obj, _args, _ctx|
      obj.classifier
    end)
  end
end
