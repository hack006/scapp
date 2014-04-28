Feature: Show coach obligation
  In order to view detailed information of coach obligation
  As admin or training owner or coach obligation user
  I want to show coach obligation detail

  Background:
    Given I am logged in
      And User test2 exists
      And Following groups exists in the system
        | name    | description       | long desc     | owner       | visibility  | is_global |
        | group1  | group1 desc       |               | test1       | public      | true     |
      And Following regular trainings exist in the system
        | name      | description     | is_public   | for_group | owner   |
        | public1   | public 1 desc   | true        | group1    | test2   |
        | private1  | private 1 desc  | false       | group1    | test1   |
      And Following currencies exist in the system
        | name      | code    | symbol    |
        | Euro      | EUR     | €         |
      And Following VATs exists
        |name   | value | is_time_limited | start_of_validity | end_of_validity |
        | Basic | 21    | false           |                   |                 |
      And Following coach obligations exist
        | regular_training  | user    | hourly_wage_wt    | vat     | currency    | coach_role  |
        | public1           | test1   | 10                | basic   | euro        | coach       |
        | public1           | test2   | 15                | basic   | euro        | head_coach  |
        | private1          | test2   | 10                | basic   | euro        | coach       |

  Scenario: I can view my coach obligation detail
    Given I am at the "/regular_trainings/public1" page
      And I have "coach" role
    When I click "Show" for "test1" in table row
    Then I should see "heading" containing "Training coach"
      And I should see "test1" in the table
      And I should see "coach" in the table
      And I should see "10" in the table
      And I should see "12.1" in the table
      And I should see "Basic" in the table

  Scenario: I can not view coach obligation detail of another coach unless I am regular training owner or admin
    Given I am at the "/regular_trainings/public1" page
    Then I shouldn't see "Show" for "head_coach" in the table row

  Scenario: I can view any coach obligation detail of regular training owned by me
    Given I have "coach" role
      And I am at the "/regular_trainings/private1" page
    When I click "Show" for "test2" in table row
    Then I should see "heading" containing "Training coach"
      And I should see "test2" in the table
      And I should see "coach" in the table

  Scenario: I can view any coach obligation detail of regular training as admin
    Given I have "admin" role
    And I am at the "/regular_trainings/public1" page
    When I click "Show" for "test2" in table row
    Then I should see "heading" containing "Training coach"
    And I should see "test2" in the table
    And I should see "coach" in the table