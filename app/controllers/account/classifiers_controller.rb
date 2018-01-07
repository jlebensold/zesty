# frozen_string_literal: true

module Account
  class ClassifiersController < ApplicationController
    before_action :authenticate_user!
    before_action :fetch_model, only: %i[edit show update destroy]

    def index
      @classifiers = Classifier.where(organization: current_user.organization)
    end

    def update
      if @classifier.update_attributes(record_params)
        redirect_to account_classifiers_path, notice: "Record has been updated."
      else
        render :edit
      end
    end

    def show; end

    def new
      @classifier = Classifier.new
    end

    def create
      @classifier = Classifier.new(record_params)

      if @classifier.save!
        redirect_to account_classifiers_path, notice: "Record has been created."
      else
        render :new
      end
    end

    def edit; end

    def destroy
      @classifier.destroy!
      redirect_to account_classifiers_path, notice: "Record has been removed."
    end

    private

    def record_params
      params.require(:classifier).permit(:name, :labels, :organization_id)
    end

    def fetch_model
      @classifier = Classifier.find(params[:id])
    end
  end
end
