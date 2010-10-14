Feature: NGO/donor can manage outgoing funding flows for their projects 
  In order to ?
  As a NGO/Donor
  I want to be able to track outgoing funding flows

@implementers
Scenario: Implementers CRUD
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page
  And I follow "Create new"
  And I select "project 1" from "Project"
  And I select "UNDP" from "To"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  Then I should see "Implementer was successfully created"
  And I should see "UNDP"
  When I follow "Edit" within "#main_table tbody tr:nth-child(1)"
  And I select "GoR" from "To"
  And I press "Update"
  Then I should see "Implementer was successfully updated"
  And I should see "GoR"
  When I follow "Delete"
  And I press "Delete"
  Then I should see "Implementer was successfully deleted"
  Then I should not see "GoR"

@implementers @javascript
Scenario: Implementers CRUD (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page
  And I follow "Create new"
  And I select "project 1" from "Project"
  And I select "UNDP" from "To"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  And I should see "UNDP"
  When I follow "Edit" within "#main_table tbody tr:nth-child(1)"
  And I select "GoR" from "To"
  And I press "Update"
  And I should see "GoR"
  When I will confirm a js popup
  And I follow "Delete"
  Then I should not see "GoR"

@implementers
Scenario: Search implementers
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@implementers @javascript
Scenario: Search implementers (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@implementers
Scenario: Sort implementers
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"

@implementers @javascript
Scenario: Sort implementers (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the implementers page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"

@implementers
Scenario: Creates an implementer funding flow
  Given the following organizations 
    | name   |
    | UNDP   |
    | UNAIDS |
    | WHO    |
  Given the following reporters 
     | name         | organization |
     | undp_user    | UNDP         |
     | un_aids_user | UNAIDS       |
  Given a data request with title "Req1" from "UNAIDS"
  Given a data response to "Req1" by "UNDP"
  Given a project with name "TB Treatment Project with more than 20 chars" for request "Req1" and organization "UNDP"
  Given an implementer "WHO" for project "TB Treatment Project with more than 20 chars"
  Given I am signed in as "undp_user"
  When I follow "Dashboard"
  And I follow "Edit"
  When I follow "My Data"
  And I follow "Implementers"
  Then I should be on the implementers page
  And I should see "TB Treatment Project with more than 20 chars"
  And I should see "20,000,000.00"

@wip
Scenario: Other organization creates a Funding Source, we see it under our Providers list
  Given the following organizations 
    | name   |
    | UNDP   |
    | UNAIDS |
  Given the following reporters 
     | name         | organization |
     | undp_user    | UNDP         |
     | un_aids_user | UNAIDS       |
  Given a data request with title "Req1" from "UNDP"
  Given a data response to "Req1" by "UNAIDS"
  Given the following projects 
     | name                 | request | organization |
     | TB Treatment Project | Req1    | UNAIDS       |
  Given the following funding flows 
     | to   | project              | from   | budget  |
     | UNDP | TB Treatment Project | UNAIDS | 1000.00 |
  Given I am signed in as "un_aids_user"
  When I follow "Dashboard"
  And I follow "Edit"
  And I follow "Implementers"
  Then I should see "TB Treatment Project"
  And I should see "UNDP"
  And I should see "1000.00"
