Feature: Delete coach obligation
  In order to keep actual information of coach obligations
  As admin or training owner
  I want to delete coach obligation

  Background:
    Given I am logged in
    And User test2 exists
    And Following groups exists in the system
      | name    | description       | long desc     | owner       | visibility  | is_global |
      | group1  | group1 desc       |               | test1       | public      | true     |
    And Following regular trainings exist in the system
      | name      | description     | is_public   | for_group | owner   |
      | private1  | private 1 desc  | false       | group1    | test1   |
      | private2  | private 1 desc  | false       | group1    | test2   |
    And Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    And Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 21    | false           |                   |                 |
    And Following coach obligations exist
      | regular_training  | user    | hourly_wage_wt    | vat     | currency    | coach_role  |
      | private1          | test2   | 10                | basic   | euro        | coach       |
      | private2          | test2   | 10                | basic   | euro        | head_coach  |

  @javascript
  Scenario: Delete coach obligation of owned regular training
    Given I have "coach" role
    And I am at the "/regular_trainings/private1" page
    When I click "Delete" for "test2" in table row
      And I confirm popup
    Then I should see "Coach obligation was successfully removed." message

  @javascript
  Scenario: Edit any coach obligation as admin
    Given I have "admin" role
    And I am at the "/regular_trainings/private2" page
    When I click "Delete" for "test2" in table row
      And I confirm popup
    Then I should see "Coach obligation was successfully removed." message