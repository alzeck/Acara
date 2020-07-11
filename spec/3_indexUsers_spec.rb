require 'rails_helper'
RSpec.describe "INDEX USERS", :type => :feature do

  it "Using api key to receive a list of all users" do
    user = FactoryBot.create(:user)
    user.skip_confirmation!
    user.save!
    
    visit api_users_path({apiKey: "#{user.secretkey}"})
    expect(page).to have_content(/\{"id":[\d]+,"username":"[^"]+","verification":(true|false),"bio":"[^"]*","following":[0-9]*,"followers":[0-9]+,"followingTags":\[[^\]]*\]\}/)
  end

end
