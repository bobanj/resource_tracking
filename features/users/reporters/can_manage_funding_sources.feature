Feature: NGO/donor can see incoming funding flows for their projects 
  In order to ?
  As a NGO/Donor
  I want to be able to track incoming funding flows

@funding_sources
Scenario: Funding sources CRUD
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page
  And I follow "Create new"
  And I select "project 1" from "Project"
  And I select "UNDP" from "From"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  Then I should see "Funding source was successfully created"
  And I should see "UNDP"
  When I follow "Edit" within "#main_table tbody tr:nth-child(1)"
  And I select "GoR" from "From"
  And I press "Update"
  Then I should see "Funding source was successfully updated"
  And I should see "GoR"
  When I follow "Delete"
  And I press "Delete"
  Then I should see "Funding source was successfully deleted"
  Then I should not see "GoR"

@funding_sources @javascript
Scenario: Funding sources CRUD (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page
  And I follow "Create new"
  And I select "project 1" from "Project"
  And I select "UNDP" from "From"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  And I should see "UNDP"
  When I follow "Edit" within "#main_table tbody tr:nth-child(1)"
  And I select "GoR" from "From"
  And I press "Update"
  And I should see "GoR"
  When I will confirm a js popup
  And I follow "Delete"
  Then I should not see "GoR"

@funding_sources
Scenario: Search funding sources
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@funding_sources @javascript
Scenario: Search funding sources (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@funding_sources
Scenario: Sort funding sources
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"

@funding_sources @javascript
Scenario: Sort funding sources (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the funding sources page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Project"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"

@funding_sources
Scenario: Create incoming funding flow
  Given a basic org + reporter profile, with data response, signed in
  Given a project with name "TB Treatment Project"
  When I go to the funding sources page
  And I follow "Create new"
  And I select "TB Treatment Project" from "Project"
  And I select "UNDP" from "From"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  And I should see "TB Treatment Project"
  And I should see "UNDP"
  And I should see "1,000.00"

@funding_sources
Scenario: BUG: 4335178 Redirected back to Funding Sources index after creation
  Given a basic org + reporter profile, with data response, signed in
  Given a project with name "TB Treatment Project"
  When I go to the funding sources page
  And I follow "Create new"
  And I select "TB Treatment Project" from "Project"
  And I select "GoR" from "From"
  And I fill in "Total Budget GOR FY 10-11" with "1000.00"
  And I press "Create"
  Then I should be on the funding sources page
