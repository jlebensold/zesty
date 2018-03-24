Types::ClassifierType = GraphQL::ObjectType.define do
  name "Classifier"
  field :id, !types.ID
  field :name, !types.String
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
    type types[Types::ClassifierType]
    resolve(lambda do |obj, _args, _ctx|
      obj.classifier
    end)
  end
end
