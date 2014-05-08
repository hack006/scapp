Feature: Edit regular training
  In order to manage regular training
  As admin or training owner
  I want to edit it

  Background:
    Given I am logged in
      And User test2 exists
      And Following groups exists in the system
        | name    | description       | long desc     | owner       | visibility  | is_global |
        | group1  | group1 desc       |               | test1       | public      | false     |
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | public1   | public 1 desc   | false       | group1    | test1   |
        | private1  | private 1 desc  | false       | group1    | test2   |

  Scenario: I can not edit training as player
    Given I have "player" role
      And Following regular trainings exist in the system
        | name      | description     | is_public   | owner   |
        | public2   | public 2 desc   | true        | test2   |
      And I am at the "/regular_trainings" page
    Then I shouldn't see "Edit" in the table


  Scenario: I edit my own training
    Given I have "coach" role
      And I am at the "/regular_trainings" page
    When I click "Edit" for "public1" in table row
    Then I should see "heading" containing "Edit training"
    When I fill all required fields for regular training
      | name    | description           | public    |
      | public1 | test1 changed desc    | true      |
      And I click "Save changes"
    Then I should see "Regular training was successfully updated." message
      And I should see "✓" in the regular training details

  Scenario: I edit any training as admin
    Given I have "admin" role
    And I am at the "/regular_trainings" page
    When I click "Edit" for "private1" in table row
    Then I should see "heading" containing "Edit training"
    When I fill all required fields for regular training
      | name      | description                 | public    |
      | private1  | private1 changed to public  | true      |
    And I click "Save changes"
    Then I should see "Regular training was successfully updated." message
      And I should see "✓" in the regular training details