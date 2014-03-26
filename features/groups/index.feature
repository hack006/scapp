Feature: List all user groups
  In order to have overview of groups in system
  As logged in user
  I want to see listing of groups I am permitted to see

  Background:
    Given I am logged in
      And User test2 exists
      And User test3 exists
      And Following groups exists in the system
        | name        | description         | long desc     | owner       | visibility  |
        | group1      | group1 desc         |               | test1       | owner       |
        | group2      | group2 desc         | group 2 LD    | test2       | members     |
        | group3_pub  | public group desc   |               | test3       | public      |

  Scenario: I can view all groups with :public, :registered and groups with :members I am in and owned groups
    Given I have "player" role
      And User "test1" is in group "group2"
    When I visit page "/user_groups"
    Then I should see "heading" containing "Listing user groups"
      And I should see "group1" in the table
      And I should see "group2" in the table
      And I should see "group3_pub" in the table

  Scenario: I can not see groups with :members visibility I am not assigned in and I am not owner of
    Given I have "player" role
    When I visit page "/user_groups"
    Then I should see "heading" containing "Listing user groups"
      And I should see "group1" in the table
      And I should see "group3_pub" in the table
      And I shouldn't see "group2" in the table

  Scenario: As admin I can see all groups
    Given I have "admin" role
    When I visit page "/user_groups"
    Then I should see "heading" containing "Listing user groups"
      And I should see "group1" in the table
      And I should see "group2" in the table
      And I should see "group3_pub" in the table