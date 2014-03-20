Feature: Delete relation
  In order to have possibility manage relations
  As a admin
  I want to remove relations

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And "test2" has "friend" relation with user "test3"

  @javascript
  Scenario: Delete relation
    Given I have "admin" role
    When I visit page "/user_relations"
      And I click "Delete" for "friend" in table row
      And I confirm popup
    Then I should see "Relation was successfully removed." message
      And I shouldn't see "test2" in the table
      And I shouldn't see "test3" in the table