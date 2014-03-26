Feature: Add group
  In order to organize users in groups
  As coach or admin
  I want to create new group

  Scenario: As coach or admin I add new group
    Given I am logged in
      And I have "coach" role
      And I am at the "/user_groups" page
    When I click add New group action button
    Then I should see "heading" containing "New group"
    When I fill in all necessary user group fields
      | name        | description         | long desc     | owner       | visibility  |
      | group1      | group1 desc         |               | test1       | owner       |
      And I click "Create User group"
    Then I should see "User group was successfully created." message
      And I should see "group1" in the table
      And I should see "test1" in the table
      And I should see "owner" in the table