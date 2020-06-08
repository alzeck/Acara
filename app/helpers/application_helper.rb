module ApplicationHelper
  def has_navbar
    !["sessions", "registrations", "passwords", "confirmations", "unlocks"].include? controller_name
  end
end
