Feature: Add variable field
  As a logged in user
  I want to add new variable field
  so I can extend basic variable fields built into the system.

  Only privileged users (:coach, :admin can do this)

  Background:
    Given I am logged in
      And I have ":coach" role

  Scenario: Add new variable field with selected category from list
    Given category "intelligence" exists
      And I am on the variable_field add new page
    When I fill in all necessary fields
      | name    | description           | unit  | higher_is_better  | is_numeric  |
      | IQ      | Intelligence quocient |       | true              | true        |
      And I select "intelligence" category
      And I send form
    Then I should see an successfully created message

  @javascript
  Scenario: Add new variable field and assign the new category
    Given category "intelligence" doesn't exist in my scope (user, public)
      And I am on the variable_field add new page
    Then I shouldn't see "intelligence" category in the list
    When I select option add category
      And I add category named "intelligence"
    Then I should see "intelligence" category selected
      And category "intelligence" should exist in db with my username
    When I fill in all necessary fields
      | name    | description           | unit  | higher_is_better  | is_numeric  |
      | IQ      | Intelligence quocient |       | true              | true        |
    And I select "intelligence" category
    And I send form
    Then I should see an successfully created message

  Scenario: I can only see my and public categories
    Given User test2 exists
      And following categories are available in the system
        | name      | description   | user      |
        | Strength  | Strength desc |           |
        | Health    | Health desc   | test1     |
        | Dimensions| Dim. desc.    | test2     |
      And I am on the variable_field add new page
    Then As user with username "test1" I should see "Strength" and "Health" but not "Dimensions"