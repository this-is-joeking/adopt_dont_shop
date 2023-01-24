# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many :application_pets }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe '#adopt_pet' do
    it 'adds a pet to an application' do
      shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      pet2 = Pet.create(name: 'Scrappy', age: 2, breed: 'Terrior', adoptable: true, shelter_id: shelter.id)
      application = Application.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                        state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')

      expect(application.pets).to eq([])

      application.adopt_pet(pet)
      application.adopt_pet(pet2)

      expect(application.pets).to eq([pet, pet2])
    end
  end

  describe '#uniq_app_pets_status' do
    it 'returns array of unique application pet statuses for the application' do
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      pet2 = Pet.create!(name: 'Scrappy', age: 2, breed: 'Terrior', adoptable: true, shelter_id: shelter.id)
      application = pet.applications.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                             state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')
      application.pets << pet2

      expect(application.uniq_app_pets_status).to eq(['Pending'])

      application.application_pets.second.reject

      expect(application.uniq_app_pets_status).to eq(['Pending', 'Rejected'])

      application.application_pets.first.reject

      expect(application.uniq_app_pets_status).to eq(['Rejected'])
    end
  end

  describe '#accept_application' do
    it 'can accept an application' do
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      application = pet.applications.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                             state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')

      expect(application.app_status).to eq('Pending')

      application.accept_application

      expect(application.app_status).to eq('Approved')
    end
  end

  describe '#reject_application' do
    it 'can reject an application' do
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      application = pet.applications.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                             state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')

      expect(application.app_status).to eq('Pending')

      application.reject_application

      expect(application.app_status).to eq('Rejected')
    end
  end

  describe '#update_app_status' do
    it 'updates app status to approved if all app pets approved' do
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      application = pet.applications.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                             state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')
      application.update_app_status

      expect(application.app_status).to eq('Pending')

      application.application_pets.first.approve
      application.update_app_status

      expect(application.app_status).to eq('Approved')
    end

    it 'updates app status to rejected if any app pet is rejected and none are pending' do
      shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      pet1 = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      application = pet1.applications.create!(name: 'John Doe', street: '123 N Washington Ave.', city: 'Denver',
                                              state: 'Colorado', zip: '91234', applicant_argument: 'caring and loving', app_status: 'Pending')
      pet2 = Pet.create!(name: 'Scrappy', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      application.pets << pet2
      application.application_pets.first.approve
      application.update_app_status

      expect(application.app_status).to eq('Pending')

      application.application_pets.second.reject
      application.update_app_status

      expect(application.app_status).to eq('Rejected')
    end
  end
end
