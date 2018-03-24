Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"


	field :createClassifier, Types::ClassifierType do
		description "Create classifier"
		argument :name, !types.String
		argument :labels, !types.String

		resolve(lambda do |_o, args, ctx|
			Classifier.create({
				organization_id: ctx[:current_user].organization_id,
				name: args[:name],
				labels: args[:labels]
			})
		end)
	end

  # TODO: Remove me
  field :testField, types.String do
    description "An example field added by the generator"
    resolve ->(obj, args, ctx) {
      "Hello World!"
    }
  end
end
