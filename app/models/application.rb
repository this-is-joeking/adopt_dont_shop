class Application < ApplicationRecord
  validates :name, exclusion: [""]
  validates :street, exclusion: [""]
  validates :city, exclusion: [""]
  validates :state, exclusion: [""]
  validates :zip, exclusion: [""]
  validates :applicant_argument, exclusion: [""]

  has_many :application_pets
  has_many :pets, through: :application_pets

  def adopt_pet(pet)
    self.pets << pet
  end
  
  def uniq_app_pets_status
    application_pets.pluck(:status).uniq
  end

  def accept_application
    self.update(app_status: "Approved")
  end

  def reject_application
    self.update(app_status: "Rejected")
  end

  def update_app_status
    if self.uniq_app_pets_status == ["Approved"]
      self.accept_application
    elsif !self.uniq_app_pets_status.include?("Pending")
      self.reject_application
    end
  end
end
