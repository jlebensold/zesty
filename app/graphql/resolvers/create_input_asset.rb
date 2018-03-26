# frozen_string_literal: true

class Resolvers::CreateInputAsset < GraphQL::Function
  description "Create Input Asset"
  argument :classifierId, !types.ID
  argument :label, !types.String
  argument :file, !::Types::FileType


  type !types.String


  def call(_o, args, ctx)
    classifier = Classifier.find_by(
      id: args[:classifierId],
      organization_id: ctx[:current_user].organization_id
    )
    pp classifier
    pp args
    classifier.input_assets.create(label: args[:label], attachment: args[:file])
    "success"
  end
end
