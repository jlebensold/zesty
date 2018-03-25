# frozen_string_literal: true

class Resolvers::CreateClassifier < GraphQL::Function
  description "Create classifier"
  argument :name, !types.String
  argument :labels, !types.String

  type Types::ClassifierType

  def call(_o, args, ctx)
    Classifier.create(
      organization_id: ctx[:current_user].organization_id,
      name: args[:name],
      labels: args[:labels]
    )
  end
end
