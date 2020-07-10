require "rails_helper"
RSpec.describe Comment, :type => :model do
  
  before(:all) do
    @comment = create(:comment)
  end
  
  it "is valid with valid attributes" do
    expect(@comment).to be_valid
  end
  
  it "is not valid if self reply" do
    comment2 = build(:comment, previous_id: self.id)
    expect(comment2).to_not be_valid
  end

  it "is not valid if reply of another event comment" do
    event2 = create(
        title: "Titolo",
        description: "Descrizione",
        start: "Sun, 12 Jul 2020 00:00:00 +0000".to_datetime,
        ends: "Mon, 13 Jul 2020 00:00:00 +0000".to_datetime,
        where: "Molina Aterno, Abruzzo, Italia",
        cords: "42.14621,13.73623",
        modified: "false"
    )
    comment3 = build(:comment, event_id: event2.id)
    comment2 = build(:comment, previous_id: comment3.id)
    expect(comment2).to_not be_valid
  end

  it "is not valid if reply of another reply" do
    comment3 = build(:comment, previous_id: @comment.id)
    comment2 = build(:comment, previous_id: comment3.id)
    expect(comment2).to_not be_valid
  end

  it "is not valid without content" do
    comment2 = build(:comment, content: nil)
    expect(comment2).to_not be_valid
  end
  
end