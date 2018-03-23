Types::ClassificationJobType = GraphQL::ObjectType.define do
  name "ClassificationJob"
  field :id, !types.ID
  field :status, !types.String
  field :job_number, !types.Int

  field :output_assets do
    type types[Types::OutputAssetType]
    description "all the output_assets!"
    resolve(lambda do |obj, _args, _ctx|
      obj.output_assets
    end)
  end
end
