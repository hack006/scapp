Feature: Show dashboard with latest and most important data
  As a logged in user
  I want to see latest information
  so I can quickly analyze important news and navigate further

  Background:
    Given I am logged in
      And User test2 exists
      And following categories are available in the system
        | name    | description             | is_global | user        |
        | C1      | desc1                   | true      |             |
      And Following variable fields exist in system
        | name    | description             | is_global | is_numeric  | category    | user        |
        | IQ1     | intelligence quocient   | true      | true        | C1          |             |
        | IQ1-str | intelligence quocient   | true      | false       | C1          |             |
      And Following measurements exists
        | vf_name | int_value | str_value   | locality  | measured_at       | for_user    |
        | IQ1     | 12        |             | Prague    | 2012/01/20 15:00  | test1       |
        | IQ1     | 15        |             | Prague    | 2012/04/20 16:00  | test1       |
        | IQ1     | 100       |             | Prague    | 2012/01/20 15:00  | test2       |
        | IQ1-str |           | good        | Rome      | 2012/01/20 15:00  | test1       |
        | IQ1-str |           | perfect     | London    | 2012/02/20 15:00  | test1       |

  Scenario: As a player I want to see my most important data
    Given I have "player" role
      And "test2" has "coach" relation with user "test1"
      And "test1" has "coach" relation with user "test2"
    When I am at the "/" page
    Then I should see "heading" containing "Closest trainings"
      And I should see "heading" containing "Latest measurements"
        And I should see measurement with value "12"
        And I should see measurement with value "15"
        And I should see measurement with value "good"
        And I should see measurement with value "perfect"
        And I shouldn't see measurement with value "100"
      And I should see "heading" containing "My connected coaches"
        And I should see coach with name "test2"
        And I shouldn't see coach with name "test1"

  Scenario: As a coach I want to see most important and latest data of my players
    Given I have "coach" role
    When I am at the "/" page
    Then I should see "heading" containing "Closest trainings trained by me"
      And I should see "heading" containing "Latest measurements of my players"

  Scenario: As an admin I want to see all globally important events
    Given I have "admin" role
    
    