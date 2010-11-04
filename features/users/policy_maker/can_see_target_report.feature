Feature: In order to reduce costs
  As a policy maker
  I want to be able to see Targets vs total coding Budgets


# These screens need to be driven from a different user role, since we are just using 
# admin at the moment.

Scenario: See Target Review screen
    Given I am signed in as an admin
    When I follow "Dashboard"
    And I follow "Review Targets vs Budgeted"
    Then I should see "Targets vs Budget"
    