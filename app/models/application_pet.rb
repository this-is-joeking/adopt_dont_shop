class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def approve
    update(approved: "Approved")
  end

  def reject
    update(approved: "Rejected")
  end

  def self.find_by_pet_and_app(arg_pet_id, arg_application_id)
    find_by(pet_id: arg_pet_id, application_id: arg_application_id)
  end
end