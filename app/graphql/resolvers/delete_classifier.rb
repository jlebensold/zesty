# frozen_string_literal: true

class Resolvers::DeleteClassifier < GraphQL::Function
  description "Delete classifier"
  argument :id, !types.ID
  type types.String

  def call(_o, args, ctx)
    Classifier.find_by(
      organization_id: ctx[:current_user].organization_id,
      id: args[:id]
    ).destroy!
    "success"
  end
end
