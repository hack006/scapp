Feature: List existing currencies
  In order to have overview of existing currencies in the system
  As admin
  I can see currencies listing
  
  Scenario: I see all currencies as admin
    Given I am logged in
      And I have "admin" role
      And Following currencies exist in the system
        | name                | code    | symbol    |
        | Euro                | EUR     | €         |
        | American Dollar     | USD     | $         |
    When I visit page "/currencies"
    Then I should see "heading" containing "Currencies"
      And I should see "Euro" in the table
      And I should see "American Dollar" in the table
    
  Scenario: I can not see currencies as coach
    Given I am logged in
      And I have "coach" role
    Then I shouldn't see "link" containing "Currencies"
    When I visit page "/currencies"
    Then I should see "You don't have required permissions!" message
    
    
  Scenario: I can not see currencies as player
    Given I am logged in
      And I have "player" role
    Then I shouldn't see "link" containing "Currencies"
    When I visit page "/currencies"
    Then I should see "You don't have required permissions!" message