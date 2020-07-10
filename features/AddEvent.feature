Feature: Update an event
Scenario: UpdateEvent
    Given I am a new user
    Given I am on the Acara home page
    When I follow "Log In"
    Then I should be on the log in page
    When I fill in "Login" with "Cucumber"
    And I fill in "Password" with "Cucumber1!"
    And I press "Log in"
    Then I should be on the Acara home page
    Given I have an event
    When I go to the event page
    Then I should be on the event page
    When I follow "Modify"
    Then I should be on the updating an event page
    When I fill in "Title" with "Sagra di Molina Aterno"
    And I press "Update Event"
    Then I should be on the event page
    And I should see "Sagra di Molina Aterno"
