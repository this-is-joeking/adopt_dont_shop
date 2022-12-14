class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.all.sort_reverse_alpha
    @shelters_pending = Shelter.pending
  end

  def show
    @shelter_name_address = Shelter.find_name_and_address(params[:id])
    shelter = Shelter.find(params[:id])
    @avg_pet_age = shelter.avg_pet_age
  end
end