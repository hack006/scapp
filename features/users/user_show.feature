Feature: Show Users
  As a coach or an administrator
  I want to see registered users
  so I can know who is registered

    Scenario: View users as player is not allowed
      Given I am logged in
      And I have "player" role
      When I look at the list of users
      Then I should see "You don't have required permissions!" message

    Scenario: View users as coach
      Given I am logged in
        And I have "coach" role
      When I look at the list of users
      Then I should see my name

    Scenario: View users as admin
      Given I am logged in
      And I have "admin" role
      When I look at the list of users
      Then I should see my name

