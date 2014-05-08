Feature: List all user variable fields with latest measurements
  As a logged in user
  I want to view my variable fields (VF) with latest results
  so I can analyze my sport results and latest trends of my efficiency

  Only :owner, :coach and :admin can see user VFs! Another players mustn't.

  Background:
    Given I am logged in
      And User test2 exists
      And following categories are available in the system
        | name    | description             | is_global | user        |
        | C1      | desc1                   | true      |             |
        | C2      | desc2                   | false     | test1       |
      And Following variable fields exist in system
        | name    | description             | is_global | is_numeric  | category    | user        |
        | IQ1     | intelligence quocient   | true      | true        | C1          |             |
        | IQ2     | intelligence quocient2  | false     | true        | C1          | test2       |
        | IQ3-str | intelligence quocient3  | false     | false       | C2          | test1       |
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test1       |
        | IQ1     | 15        |             | Prague    | 2012/04/20 16:00  | test1       |
        | IQ1     | 18        |             | Prague    | 2012/03/20 17:00  | test1       |
        | IQ1     | 100       |             | Prague    | 2012/01/20 15:00  | test2       |
        | IQ2     | 100       |             | Prague    | 2012/01/20 15:00  | test2       |
        | IQ3-str |           | good        | Rome      | 2012/01/20 15:00  | test1       |
        | IQ3-str |           | perfect     | London    | 2012/02/20 15:00  | test1       |


  Scenario: I want to view my VFs
    Given I have "player" role
    When I visit variable_field view results page of "test1"
    Then I should see "heading" containing "IQ1"
      And I should see "heading" containing "IQ3-str"
      And I shouldn't see "heading" containing "IQ2"
      And "IQ1" "best" value should be "18"
      And "IQ1" "worst" value should be "12"
      And "IQ1" "current" value should be "15"
      And "IQ3-str" "current" value should be "perfect"

  Scenario: I want to view another player VFs as :player
    Given I have "player" role
    When I visit variable_field view results page of "test2"
    Then I should see "You don't have required permissions!" message

  Scenario: I want to view player VFs as :coach
    Given I have "coach" role
      And I have "coach" relation with user "test2"
    When I visit variable_field view results page of "test2"
    Then I should see "heading" containing "User variable fields"
      And I should see "heading" containing "IQ1"
      And I should see "heading" containing "IQ2"
      And "IQ1" "best" value should be "100"
      And "IQ1" "worst" value should be "100"
      And "IQ1" "current" value should be "100"

  Scenario: I want to view player VFs as :admin
    Given I have "admin" role
    When I visit variable_field view results page of "test2"
    Then I should see "heading" containing "User variable fields"
      And I should see "heading" containing "IQ1"
      And I should see "heading" containing "IQ2"
      And "IQ1" "best" value should be "100"
      And "IQ1" "worst" value should be "100"
      And "IQ1" "current" value should be "100"