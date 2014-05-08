Feature: Remove regular training
  In order to manage regular trainings
  As admin or training owner
  I want to have possibility to remove training
  
  Background: 
    Given I am logged in
      And User test2 exists
      And Following groups exists in the system
        | name    | description       | long desc     | owner       | visibility  |
        | group1  | group1 desc       |               | test1       | public      |
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | public1   | public 1 desc   | false       | group1    | test1   |
        | private1  | private 1 desc  | false       | group1    | test2   |

  @javascript
  Scenario: I want to remove my training
    Given I have "coach" role
      And I am at the "/regular_trainings" page
    When I click "Delete" for "public1" in table row
      And I confirm popup
    Then I should see "Regular training was successfully removed." message
      And I shouldn't see "public1" in the table

  @javascript
  Scenario: I want to remove any training as admin
    Given I have "admin" role
    And I am at the "/regular_trainings" page
    When I click "Delete" for "private1" in table row
    And I confirm popup
    Then I should see "Regular training was successfully removed." message
    And I shouldn't see "private1" in the table