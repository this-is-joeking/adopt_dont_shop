# frozen_string_literal: true

class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:application_id])
    @pets = @application.pets
    @searched_pets = if params[:pet_search].present?
                       Pet.search(params[:pet_search])
                     else
                       []
                     end

    return unless params[:pet].present?

    pet = Pet.find(params[:pet])
    @application.adopt_pet(pet)
  end

  def new
  end

  def update
    application = Application.find(params[:id])
    application.update(app_params)
    redirect_to "/applications/#{application.id}"
  end

  def create
    @application = Application.new(app_params)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      flash[:notice] = 'Application not created. Please fill out all fields.'
      render :new
    end
  end

  private

  def app_params
    params.permit(:name, :street, :city, :zip, :state, :applicant_argument, :app_status)
  end
end
