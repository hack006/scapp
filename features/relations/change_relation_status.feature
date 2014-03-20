Feature: Change relation status
  In order to accept, refuse relations
  As a logged in user with required permissions
  I want to change relation states of my side of connection
  
  Background: 
    Given I am logged in
      And User test2 exists
    
  Scenario: I want to confirm new relation
    Given I have "player" role
      And "test2" has "new" "coach" relation with "test1"
    When I visit page "/users/test1/relations"
    Then I should see "test2" in table "new_relations"
    When I click "Accept relation" for "test2" in table row
    Then I should see "User relation status was successfully changed to: accepted." message
      And I should see "test2" in table "active_relations"

  Scenario: I want to refuse new relation
    Given I have "player" role
    And "test2" has "new" "coach" relation with "test1"
    When I visit page "/users/test1/relations"
    Then I should see "test2" in table "new_relations"
    When I click "Refuse relation" for "test2" in table row
    Then I should see "User relation status was successfully changed to: refused." message
    And I should see "test2" in table "refused_relations"

  Scenario: I want to refuse active relation
    Given I have "player" role
    And "test2" has "accepted" "coach" relation with "test1"
    When I visit page "/users/test1/relations"
    Then I should see "test2" in table "active_relations"
    When I click "Refuse relation" for "test2" in table row
    Then I should see "User relation status was successfully changed to: refused." message
    And I should see "test2" in table "refused_relations"