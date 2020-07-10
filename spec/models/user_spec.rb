require "rails_helper"
RSpec.describe User, :type => :model do
  
  before(:all) do
    @user = create(:user)
  end
  
  it "is valid with valid attributes" do
    expect(@user).to be_valid
  end

  it "has not a complex password" do
    user2 = build(:user, password: "password")
    expect(user2).to_not be_valid
  end

  it "has not a valid username" do
    user2 = build(:user, username: "?")
    expect(user2).to_not be_valid
  end
  
  it "has not a unique email" do
    user2 = build(:user, username: "example")
    expect(user2).to_not be_valid
  end

  it "has not a unique username" do
    user2 = build(:user, email: "example2@mail.com")
    expect(user2).to_not be_valid
  end

  it "is not valid without an email" do 
    user2 = build(:user, email: nil)
    expect(user2).to_not be_valid
  end
  
  it "is not valid without a username" do 
    user2 = build(:user, username: nil)
    expect(user2).to_not be_valid
  end

  it "is not valid without a password" do 
    user2 = build(:user, password: nil)
    expect(user2).to_not be_valid
  end

  it "is not valid without a verification" do 
    user2 = build(:user, verification: nil)
    expect(user2).to_not be_valid
  end
  
end