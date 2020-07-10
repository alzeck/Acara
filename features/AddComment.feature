Feature: Aggiungere un commento ad un evento
Scenario: AddComment
    Given I am on the Acara home page
    When I follow "Sign Up"
    Then I should be on the Acara_signup
    When I fill in "user[username]" with "utente"
    And I fill in "user[email]" with "mail@user"
    And I fill in "user[password]" with "prova"
    And I fill in "user[password1]" with "prova"
    And I press "Sign up"
    Then I should be on the Acara_login
    And I fill in "user[username]" with "utente"
    And I fill in "user[password]" with "prova"
    And I press "Log In"
    Then I should be on the Acara home page
    When I fill "Event" with "Tolo Tolo" 
    Then I should be on te Acara Event
    When I follow "add comment"
    And I should write "good film" 
