# frozen_string_literal: true

class Account::InputAssetsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_classifier

  def index
  end

  def create
    redirect_to account_classifier_path(@classifier), notice: 'Job Started.'
  end


  private

  def record_params
    params.require(:input_assets).permit(attachments:{})
  end


  def fetch_classifier
    @classifier = Classifier.find(params[:classifier_id])
  end
end