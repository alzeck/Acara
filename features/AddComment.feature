Feature: Add a comment
Scenario: AddComment
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
    When I fill in the comment section with "Nice Event!"
    And I press the send comment button
    Then I should be on the event page
    And I should see "Nice Event!"
