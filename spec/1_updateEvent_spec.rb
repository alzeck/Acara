require 'rails_helper'
RSpec.describe "UPDATE EVENT", :type => :feature do

  it "User 'Rspec' login and update their event 'Sagra Molinese'" do
    user = FactoryBot.create(:user)
    event = FactoryBot.create(:event)
    page.set_rack_session('warden.user.user.key' => User.serialize_into_session(user))
    user.skip_confirmation!
    user.save!
    
    visit root_path
    expect(page).to have_content("Settings")
    click_link "Sagra Molinese"
    expect(page).to have_content("Una buona festa")
    click_link "Modify"
    expect(page).to have_button("Update Event")
    fill_in "event[title]", with: "Sagra di Molina Aterno"
    click_button "Update Event"
    expect(page).to_not have_button("Update Event")
    expect(page).to have_content("Sagra di Molina Aterno")
    expect(page).to have_content("Una buona festa")
  end

end
