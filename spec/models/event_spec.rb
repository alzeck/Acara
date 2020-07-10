require "rails_helper"
RSpec.describe Event, :type => :model do
  
  before(:all) do
    @event = create(:event)
  end
  
  it "is valid with valid attributes" do
    expect(@event).to be_valid
  end
  
  it "has not valid cords" do
    event2 = build(:event, cords: "1")
    expect(event2).to_not be_valid
  end

  it "has not where is cords" do
    event2 = build(:event, cords: "13.73623,42.14621")
    expect(event2).to_not be_valid
  end

  it "has not start before end" do
    data = "Tue, 14 Jul 2020 00:00:00 +0000".to_datetime
    event2 = build(:event, start: data)
    expect(event2).to_not be_valid
  end

  it "is not valid without where" do 
    event2 = build(:event, where: nil)
    expect(event2).to_not be_valid
  end
  
  it "is not valid without cords" do 
    event2 = build(:event, cords: nil)
    expect(event2).to_not be_valid
  end

  it "is not valid without start" do 
    event2 = build(:event, start: nil)
    expect(event2).to_not be_valid
  end

  it "is not valid without ends" do 
    event2 = build(:event, ends: nil)
    expect(event2).to_not be_valid
  end

  it "is not valid without title" do 
    event2 = build(:event, title: nil)
    expect(event2).to_not be_valid
  end

  it "is not valid without description" do 
    event2 = build(:event, description: nil)
    expect(event2).to_not be_valid
  end
  
end