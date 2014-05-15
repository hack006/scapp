Feature: Add new currency
  In order to manage more currencies
  As admin
  I can add new currency
  
  Scenario: I can add currency as admin
    Given I am logged in
      And I have "admin" role
    When I am at the "/currencies" page
    Then I should see "heading" containing "Currencies"
    When I click New currency in action box
    Then I should see "heading" containing "New currency"
    When I fill all required fields for currency
      | name    | code    | symbol  |
      | Euro    | EUR     | €       |
      And I click "Create currency"
    Then I should see "Currency was successfully created." message
      And I should see "Euro" in the table

  Scenario: As player I can not add new currency
    Given I am logged in
      And I have "player" role
    When I visit page "/currencies/new"
    Then I should see "You don't have required permissions!" message

  Scenario: As coach I can not add new currency
    Given I am logged in
    And I have "coach" role
    When I visit page "/currencies/new"
    Then I should see "You don't have required permissions!" message