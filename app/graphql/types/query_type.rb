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
    resolve ->(obj, args, ctx) {
      Rails.env
    }
  end
end
