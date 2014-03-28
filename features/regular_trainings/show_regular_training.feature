Feature: View regular training detail
  In order to view training coaches and my playmates
  As training owner, training coach, training player or training player watcher
  I want to view training detail

  Background:
    Given I am logged in
    And User test2 exists
    And Following groups exists in the system
      | name    | description       | long desc     | owner       | visibility  | is_global |
      | group1  | group1 desc       |               | test1       | public      | false     |
    And Following regular trainings exist in the system
      | name      | description     | is_public   | for_group | owner   |
      | members1  | public 1 desc   | false       | group1    | test1   |
      | private1  | private 1 desc  | false       | group1    | test2   |

  Scenario: I want to view detail of training I own
    Given I have "coach" role
      And User "test1" is in group "group1"
      And I am at the "/regular_trainings" page
    When I click "Show" for "members1" in table row
    Then I should see "heading" containing "Regular training detail"

  Scenario: I want to view detail of training I am participating in

  Scenario: I want to view detail of training I am coaching

  Scenario: I want to view detail of any training as admin