require 'rails_helper'

RSpec.describe 'admin shelters show page' do
  it 'contains the shelets name and full address' do
    shelter = Shelter.create(name: 'Mystery Building', street: "123 Main St", city: 'Irvine', state: "CA", zip: "12345", foster_program: false, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content(shelter.name)
    expect(page).to have_content(shelter.street)
    expect(page).to have_content(shelter.city)
    expect(page).to have_content(shelter.state)
    expect(page).to have_content(shelter.zip)
    expect(page).to_not have_content(shelter.rank)
    expect(page).to_not have_content(shelter.foster_program)
  end

  it 'has a statistics section which includes average age of all adoptable pets' do
    shelter = Shelter.create!(name: 'Mystery Building', street: "123 Main St", city: 'Irvine', state: "CA", zip: "12345", foster_program: false, rank: 9)
    pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    pet1 = Pet.create!(name: 'Scrappy', age: 3, breed: 'Mini Dane', adoptable: true, shelter_id: shelter.id)
    pet2 = Pet.create!(name: 'Scout', age: 2, breed: 'Terrier', adoptable: true, shelter_id: shelter.id)
    pet3 = Pet.create!(name: 'Spot', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    shelter1 = Shelter.create!(name: 'Test Shelter', street: "123 Main St", city: 'Irvine', state: "CA", zip: "12345", foster_program: false, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Shelter Statistics")
    expect(page).to have_content("Average adoptable pet age: 2")

    visit "/admin/shelters/#{shelter1.id}"

    expect(page).to have_content("Average adoptable pet age: There are no adoptable pets at this shelter")
  end

  it 'has a count of adoptable pets for the shelter' do
    shelter = Shelter.create!(name: 'Mystery Building', street: "123 Main St", city: 'Irvine', state: "CA", zip: "12345", foster_program: false, rank: 9)
    pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    pet1 = Pet.create!(name: 'Scrappy', age: 3, breed: 'Mini Dane', adoptable: false, shelter_id: shelter.id)
    pet2 = Pet.create!(name: 'Scout', age: 2, breed: 'Terrier', adoptable: true, shelter_id: shelter.id)
    pet3 = Pet.create!(name: 'Spot', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    shelter1 = Shelter.create!(name: 'Test Shelter', street: "123 Main St", city: 'Irvine', state: "CA", zip: "12345", foster_program: false, rank: 9)

    visit "/admin/shelters/#{shelter.id}"

    expect(page).to have_content("Number of Adoptable Pets: 3")

    visit "/admin/shelters/#{shelter1.id}"

    expect(page).to have_content("Number of Adoptable Pets: 0")
  end
end
