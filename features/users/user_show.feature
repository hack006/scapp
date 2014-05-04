Feature: Show User
  As a registered user
  I want to see profile of user I have required permission to
  so I can get more information about him than another users

  Background:
    Given I am logged in
      And User test2 exists

  Scenario: View user profile as player is not allowed without friend or watcher relation to user
    Given I have "player" role
    When I visit page "/users/test2"
    Then I should see "You don't have required permissions!" message

  Scenario: View user profile as player is possible with friend relation to that user
    Given I have "player" role
      And I have "friend" relation with user "test2"
    When I visit page "/users/test2"
    Then I should see "heading" containing "test2 - profile"

  Scenario: View user profile as player is possible with watcher relation to that user
    Given I have "player" role
    And I have "watcher" relation with user "test2"
    When I visit page "/users/test2"
    Then I should see "heading" containing "test2 - profile"

  Scenario: View user profile as coach is possible with coach relation to that user
    Given I have "coach" role
      And I have "coach" relation with user "test2"
    When I visit page "/users/test2"
    Then I should see "heading" containing "test2 - profile"

  Scenario: As admin I can view every profile
    Given I have "admin" role
    When I visit page "/users/test2"
    Then I should see "heading" containing "test2 - profile"

