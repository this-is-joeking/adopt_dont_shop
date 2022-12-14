class Shelter < ApplicationRecord
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true

  has_many :pets, dependent: :destroy
  has_many :applications, through: :pets

  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end
  
  def self.sort_reverse_alpha
    self.all.find_by_sql("SELECT * FROM shelters ORDER BY name desc")
  end

  def self.pending
    self.distinct.joins(:applications).where("applications.app_status = ?", "Pending").order(:name)
  end

  def self.find_name_and_address(shelter_id)
    self.all.find_by_sql("Select name, street, city, state, zip FROM shelters WHERE id = #{shelter_id}").first
  end

  def avg_pet_age
    self.pets.where(adoptable: :true).average(:age)
  end

  def num_of_adoptable_pets
    self.pets.where(adoptable: :true).size
  end
end
