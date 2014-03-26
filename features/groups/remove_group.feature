Feature: Remove group
  In order to organize users in groups
  As admin or group owner
  I want to have possibility delete it
  
  Background:
    Given I am logged in
    And User test2 exists
    And User test3 exists
    And Following groups exists in the system
      | name        | description         | long desc     | owner       | visibility  |
      | group1      | group1 desc         |               | test1       | owner       |
      | group2      | group2 desc         | group 2 LD    | test2       | members     |

  @javascript
  Scenario: I destroy owned group
    Given I have "player" role
      And I am at the "/user_groups" page
    When I click "Delete" for "group1" in table row
      And I confirm popup
    Then I should see "User group was successfully destroyed." message
      And I shouldn't see "group1" in the table

  @javascript
  Scenario: As admin I can destroy any group
    Given I have "admin" role
      And I am at the "/user_groups" page
    When I click "Delete" for "group2" in table row
      And I confirm popup
    Then I should see "User group was successfully destroyed." message
      And I shouldn't see "group2" in the table
      
    
