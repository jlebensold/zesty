# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  alias_attribute :uid, :email
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :organization

  delegate :name, to: :organization, prefix: true

  def output_assets
    OutputAsset.joins(classifier: [:organization])
               .where("classifiers.organization_id = ?", organization_id)
  end

  def classifiers
    Classifier.where(organization_id: organization_id)
  end

  def jobs
    ClassificationJob.joins(:classifier).where("classifiers.organization_id = ?", organization_id)
  end

  enum role: {
    admin: "admin",
    customer: "customer"
  }
end
