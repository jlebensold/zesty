# frozen_string_literal: true

class Resolvers::UpdateClassifier < GraphQL::Function
  description "Update classifier"
  argument :id, !types.ID
  argument :name, !types.String
  argument :labels, !types.String

  type Types::ClassifierType

  def call(_o, args, ctx)
    Classifier.find_by(
      organization_id: ctx[:current_user].organization_id,
      id: args[:id]
    ).update(
      name: args[:name],
      labels: args[:labels]
    )
  end
end
