Feature: Admin views Opsgenie rotation config
  - So that I can add and remove Opsgenie rotations
  - As an admin
  - I want to see a list of Opsgenie 'rotations' grouped by 'schedule'

  Scenario: I see rotations grouped by schedule
    Given I am authenticated as an admin
    When I visit the opsgenie config page
    Then I see lists of rotations grouped by schedule

  Scenario: I see 'active' rotations highlighted
    Given I am authenticated as an admin
    When I visit the opsgenie config page
    Then I see each active rotation visually highlighted

  Scenario: I can't see anything if not authenticated
    Given I'm not authenticated
    When I visit the opsgenie config page
    Then I see nothing
