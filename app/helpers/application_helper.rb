module ApplicationHelper
  def has_navbar
    !["sessions", "registrations", "passwords", "confirmations", "unlocks"].include? controller_name
  end

  def has_maps
    ["events"].include? controller_name
  end

end
