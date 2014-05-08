Feature: View group detail
  In order to view detailed information and listing of group users
  As a logged in user with required user
  I want to view group detail

  Background: 
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following groups exists in the system
        | name        | description         | long desc     | owner       | visibility  |
        | group1      | group1 desc         |               | test1       | owner       |
        | group2      | group2 desc         | group 2 LD    | test2       | members     |
        | group3_pub  | public group desc   |               | test3       | public      |
        | group4      | group4 desc         | group 4 LD    | test3       | registered  |

  Scenario: I can view public group with any permission
    Given I have "player" role
      And User "test2" is in group "group3_pub"
      And I am at the "/user_groups" page
    When I click "Show" for "group3_pub" in table row
    Then I should see "heading" containing "Group detail - group3_pub"
      And I should see "test2" in user group members table

  Scenario: I can view group detail with :registered visibility if I am logged in
    Given I have "player" role
      And User "test2" is in group "group4"
      And I am at the "/user_groups" page
    When I click "Show" for "group4" in table row
    Then I should see "heading" containing "Group detail - group4"
      And I should see "test2" in user group members table

  Scenario: I can view group details with :members visibility if I am member
    Given I have "player" role
      And User "test1" is in group "group2"
      And User "test3" is in group "group2"
      And I am at the "/user_groups" page
    When I click "Show" for "group2" in table row
    Then I should see "heading" containing "Group detail - group2"
      And I should see "test1" in user group members table
      And I should see "test3" in user group members table

  Scenario: I can not view group details with members visibility if I am not member and I am have not admin role
    Given I have "player" role
      And User "test3" is in group "group2"
    When I am at the "/user_groups" page
    Then I shouldn't see "group2" in the table
