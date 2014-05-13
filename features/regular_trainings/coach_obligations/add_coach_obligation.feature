Feature: Add coach obligation
  In order to manage coach obligations
  As admin or training owner
  I want to add coach obligation

  Background:
    Given I am logged in
    And User test2 exists
    And Following groups exists in the system
      | name    | description       | long desc     | owner       | visibility  | is_global |
      | group1  | group1 desc       |               | test1       | public      | true     |
    And Following regular trainings exist in the system
      | name      | description     | is_public   | for_group | owner   |
      | private1  | private 1 desc  | false       | group1    | test1   |
    And Following currencies exist in the system
      | name      | code    | symbol    |
      | Euro      | EUR     | €         |
    And Following VATs exists
      |name   | value | is_time_limited | start_of_validity | end_of_validity |
      | Basic | 21    | false           |                   |                 |
    
  Scenario: As regular training owner I can add new coach obligation
    Given I have "coach" role
      And I am at the "/regular_trainings/private1" page
    When I click "Add new coach"
    Then I should see "heading" containing "New training coach"
    When I fill in all necessary coach obligation fields
      | coach_email           | hourly_wage_wt    | vat     | currency    | coach_role  |
      | example1@example.com  | 10                | Basic   | Euro        | coach       |
      And I click "Create coach obligation"
    Then I should see "Coach obligation was successfully created." message
      And I should see "test1" for "Coach" in the table row

  Scenario: As admin I can add new coach obligation
    Given I have "admin" role
      And I am at the "/regular_trainings/private1" page
    When I click "Add new coach"
    Then I should see "heading" containing "New training coach"
    When I fill in all necessary coach obligation fields
      | coach_email           | hourly_wage_wt    | vat     | currency    | coach_role  |
      | example1@example.com  | 10                | Basic   | Euro        | coach       |
        And I click "Create coach obligation"
    Then I should see "Coach obligation was successfully created." message
      And I should see "test1" for "Coach" in the table row