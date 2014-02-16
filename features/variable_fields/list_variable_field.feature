Feature: List variable fields
  In order to have an overview of available variable fields and have possibility to edit, delete, view details and filter
  As a coach
  I want to show list of variable fields

  Background:
    # as user1
    Given I am logged in
      And  I have "coach" role

  Scenario: View list of my added and global variable fields
    Given category "intelligence" exists
      And another user owning category exists
      And Following variable fields exist in system
        | name        | description         | category     | user      |
        | IQ          | inteligence quoc.   | intelligence | test1     |
        | memory      | abcd                | intelligence | test2     |
        | orientation | orientation in space| intelligence |           |
      And I am on the variable fields index page
    Then I should see following names in the table
      | IQ | orientation |
      And I shouldn't see following names in the table
        | memory |
      And I should have edit, delete, view actions available for "IQ"
      And I should have no actions available for "orientation"
