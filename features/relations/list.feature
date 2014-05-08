Feature: List relations
  In order to have an overview of my relations (all relation in case of admin)
  As a logged in user
  I want to have possibility to list relations

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And User test4 exists
      And "test2" has "new" "coach" relation with "test1"
      And "test2" has "refused" "watcher" relation with "test1"
      And "test4" has "watcher" relation with me

  Scenario: As a player I want to see my friends, coaches and watchers
    Given I have "friend" relation with user "test2"
      And "test3" has "coach" relation with me
    When I visit page "/users/test1/relations"
    Then I should see "heading" containing "Active relations"
      And I should see "heading" containing "Pending relations"
      And I should see "heading" containing "Refused relations"
      And I should see "test2" in table "active_relations"
      And I should see "test3" in table "active_relations"
      And I should see "test4" in table "active_relations"
      And I should see "test2" in table "refused_relations"
      And I should see "test2" in table "new_relations"

  Scenario: As a player I can not view relations of other users
    When I visit page "/users/test2/relations"
    Then I should see "You don't have required permissions!" message

  Scenario: As a coach I want to be able to see relations of my players
    Given I have "coach" role
      And I have "coach" relation with user "test3"
      And "test2" has "new" "friend" relation with "test3"
    When I visit page "/users/test3/relations"
    Then I should see "heading" containing "Active relations"
      And I should see "heading" containing "Pending relations"
      And I should see "heading" containing "Refused relations"
      And I should see "test1" in table "active_relations"
      And I should see "test2" in table "new_relations"
      And I shouldn't see table "refused_relations"
      And I shouldn't see "test2" in the table "active_relations"
    When I visit page "/users/test4"
      Then I should see "You don't have required permissions!" message

  Scenario: As admin I want to see relations of all people
    Given I have "admin" role
      And "test3" has "friend" relation with me
    When I visit page "/users/test3/relations"
    Then I should see "heading" containing "Active relations"
      And I should see "heading" containing "Pending relations"
      And I should see "heading" containing "Refused relations"
      And I should see "test1" in table "active_relations"
      And I shouldn't see table "new_relations"
      And I shouldn't see table "refused_relations"
