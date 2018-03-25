# frozen_string_literal: true

Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :me do
    type Types::UserType
    description "who is currently logged in"
    resolve(lambda do |_obj, _args, ctx|
      ctx[:current_user]
    end)
  end

  field :env, types.String do
    description "env"
    resolve ->(_obj, _args, _ctx) {
      Rails.env
    }
  end
end
