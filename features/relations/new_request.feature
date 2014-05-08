Feature: Request new relation
  In order to connect with other users
  As a logged in user
  I want to request new relation
  
  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists

  Scenario: I want to request new friend relation
    Given I have "player" role
    When I visit page "/users/test1/relations"
    Then I shouldn't see table "active_relations"
      And I shouldn't see table "new_relations"
      And I shouldn't see table "refused_relations"
    When I click "New relation"
    Then I should see "heading" containing "New relation"
    When I fill in all necessary relation fields
      | to_user_mail          | relation_type |
      | example2@example.com  | friend        |
      And I click button "Create user relation"
    Then I should see "Relation was successfully created." message
      And I should see "test2" in table "active_relations"


  Scenario: I want to request new friend relation which already exists
    Given I have "player" role
      And I have "friend" relation with user "test2"
    When I visit page "/users/test1/relations"
    Then I should see "test2" in table "active_relations"
      And I shouldn't see table "new_relations"
      And I shouldn't see table "refused_relations"
    When I click "New relation"
    Then I should see "heading" containing "New relation"
    When I fill in all necessary relation fields
      | to_user_mail          | relation_type |
      | example2@example.com  | friend        |
    And I click button "Create user relation"
    Then I should see "Relation of type friend between you and test2 already exists. Can not create new one!" message
