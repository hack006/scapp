Feature: Add new relation to any user with any status
  In order to manage relations for other users
  As admin
  I want to add new relations to any user with any status

  Scenario: Add new user relation
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And I have "admin" role
    When I visit page "/user_relations"
      And I click "Create new relation"
    Then I should see "heading" containing "New relation"
    When I fill in all necessary user relations (all) fields
      | relation    | from_user_mail        | to_user_mail          | from_user_status    | to_user_status  |
      | friend      | example2@example.com  | example3@example.com  | accepted            | accepted        |
      And I click "Create user relation"
    Then I should see "Relation was successfully created." message
      And I should see "test2" in the table
      And I should see "test3" in the table