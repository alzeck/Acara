Feature: Receive a list of all users from the API
Scenario: IndexUser
    Given I am a new user
    When I am on the users api page
    Then I should see /\{"id":[\d]+,"username":"[^"]+","verification":(true|false),"bio":"[^"]*","following":[0-9]*,"followers":[0-9]+,"followingTags":\[[^\]]*\]\}/
