# frozen_string_literal: true

class Resolvers::DeleteInputAsset < GraphQL::Function
  description "Delete input asset"
  argument :id, !types.ID
  type types.String

  def call(_o, args, ctx)
    asset = InputAsset.joins(:classifier)
                      .where("classifiers.organization_id = ?", ctx[:current_user].organization_id)
                      .find_by(id: args[:id])
    asset.destroy!
    "success"
  end
end
