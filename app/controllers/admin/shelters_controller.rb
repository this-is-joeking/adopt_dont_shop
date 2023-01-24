# frozen_string_literal: true

module Admin
  class SheltersController < ApplicationController
    def index
      @shelters = Shelter.all.sort_reverse_alpha
      @shelters_pending = Shelter.pending
    end

    def show
      @shelter_name_address = Shelter.find_name_and_address(params[:id])
      shelter = Shelter.find(params[:id])
      @avg_pet_age = shelter.avg_pet_age
      @avg_pet_age = 'There are no adoptable pets at this shelter' if @avg_pet_age.nil?
      @num_of_adoptable_pets = shelter.num_of_adoptable_pets
      @num_of_adopted_pets = shelter.num_of_adopted_pets
    end
  end
end
