# frozen_string_literal: true

module Admin
  class ApplicationsController < ApplicationController
    def show
      @application = Application.find(params[:id])
      @pets = @application.pets
      @application_pets = @application.application_pets
      @application.update_app_status
    end

    def update
      @application_pet = ApplicationPet.find(params[:app_pet_id])
      if params[:pet_id]
        @application_pet.approve
      elsif params[:reject_pet_id]
        @application_pet.reject
      end
      redirect_to "/admin/applications/#{params[:id]}"
    end
  end
end
