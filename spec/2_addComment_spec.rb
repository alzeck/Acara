require 'rails_helper'
RSpec.describe "ADD COMMENT", :type => :feature do

  it "User 'Rspec' login and comment 'Nice Event!' on their event 'Sagra Molinese'" do
    user = FactoryBot.create(:user)
    event = FactoryBot.create(:event)
    page.set_rack_session('warden.user.user.key' => User.serialize_into_session(user))
    user.skip_confirmation!
    user.save!
    
    visit root_path
    expect(page).to have_content("Settings")
    click_link "Sagra Molinese"
    expect(page).to have_content("Una buona festa")
    expect(page).to_not have_content("Nice Event!")
    find('#comment_content').set("Nice Event!")
    find('#comment_submit').click
    expect(page).to have_content("Una buona festa")
    expect(page).to have_content("Nice Event!")
  end

end
