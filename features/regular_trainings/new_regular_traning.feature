Feature: Add new regular training
  In order to manage regular trainings
  As coach or admin
  I want to add new regular training

  Background:
    Given I am logged in

  Scenario: As player I can not add training
    Given I have "player" role
    When I visit page "/regular_trainings"
    Then I shouldn't see "link" containing "New training"

  Scenario: As coach I want to add new regular training
    Given I have "coach" role
      And Following groups exists in the system
        | name    | description       | long desc     | owner       | is_global | visibility  |
        | group1  | group1 desc       |               | test1       | true      | public      |
    When I visit page "/regular_trainings"
      And I click New training in action box
    Then I should see "heading" containing "New training"
    When I fill all required fields for regular training
      | name    | description   | public    | for_group   |
      | test1   | test1 desc    | false     | group1      |
      And I click "Create regular training"
    Then I should see "Regular training was successfully created." message