Feature: Add user to group
  In order to manage members of group
  As an group owner or admin
  I want to add new members

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following groups exists in the system
        | name        | description         | long desc     | owner       | visibility  |
        | group1      | group1 desc         |               | test1       | owner       |
        | group2      | group2 desc         | group 2 LD    | test2       | members     |

  Scenario: I add new member I have relation with to my group
    Given I have "player" role
      And I have "coach" relation with user "test2"
      And I am at the "/user_groups" page
    When I click "Show" for "group1" in table row
    Then I should see "heading" containing "Group detail"
      And I shouldn't see "test2" in user group members table
      And I shouldn't see "test3" in user group members table
    When I fill in email "example2@example.com" for adding new user
      And I click "Add user to group"
    Then I should see "User successfully added." message
    And I should see "test2" in user group members table

  Scenario: As admin I can add any member to any group
    Given I have "admin" role
      And I am at the "/user_groups" page
    When I click "Show" for "group1" in table row
    Then I should see "heading" containing "Group detail"
      And I shouldn't see "test2" in user group members table
      And I shouldn't see "test3" in user group members table
    When I fill in email "example2@example.com" for adding new user
      And I click "Add user to group"
    Then I should see "User successfully added." message
      And I should see "test2" in user group members table