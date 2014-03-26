Feature: Remove user from group
  In order to manage members of group
  As an group owner or admin
  I want to remove group members

  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name        | description         | long desc     | owner       | visibility  |
      | group1      | group1 desc         |               | test1       | owner       |
      | group2      | group2 desc         | group 2 LD    | test2       | members     |
    And User "test2" is in group "group1"
    And User "test3" is in group "group2"

  Scenario: I remove member from my group
    Given I have "player" role
      And I am at the "/user_groups" page
    When I click "Show" for "group1" in table row
      Then I should see "heading" containing "Group detail"
      And I should see "test2" in user group members table
    When I click "Delete" for "test2" in table row
      Then I should see "User successfully removed." message
      And I shouldn't see "test2" in user group members table

  Scenario: I can not remove member from group I do not own
    Given I have "player" role
      And User "test1" is in group "group2"
      And I am at the "/user_groups" page
    When I click "Show" for "group2" in table row
    Then I should see "heading" containing "Group detail"
      And I should see "test1" in user group members table
      And I should see "test3" in user group members table
      And I shouldn't see "Delete" in user group members table

  Scenario: As admin I remove member from not my group
    Given I have "admin" role
    And I am at the "/user_groups" page
    When I click "Show" for "group2" in table row
    Then I should see "heading" containing "Group detail"
    And I should see "test3" in user group members table
    When I click "Delete" for "test3" in table row
    Then I should see "User successfully removed." message
    And I shouldn't see "test3" in user group members table