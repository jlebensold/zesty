# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # Classifiers

  field :deleteClassifier, function: Resolvers::DeleteClassifier.new
  field :updateClassifier, function: Resolvers::UpdateClassifier.new
  field :createClassifier, function: Resolvers::CreateClassifier.new

  # Assets
  # create
  # destroy
  field :deleteInputAsset, function: Resolvers::DeleteInputAsset.new

  # Jobs

  field :runBuild, function: Resolvers::RunBuild.new
end
