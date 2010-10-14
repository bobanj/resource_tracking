Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my projects

@projects
Scenario: Project CRUD
  Given a basic org + reporter profile, with data response, signed in
  When I go to the projects page for "Req1"
  And I follow "Create new"
  And I fill in "project_name" with "My project"
  And I fill in "project_start_date" with "2010-01-01"
  And I fill in "project_end_date" with "2010-01-02"
  And I press "Create"
  Then I should see "Project was successfully created"
  And I should see "My project"
  When I follow "Edit"
  And I fill in "project_name" with "My new project"
  And I press "Update"
  Then I should see "Project was successfully updated"
  Then I should see "My new project"
  When I follow "Delete"
  And I press "Delete"
  Then I should see "Project was successfully deleted"
  Then I should not see "My new project"


@projects @javascript
Scenario: Project CRUD (with JS)
  Given a basic org + reporter profile, with data response, signed in
  When I go to the projects page for "Req1"
  And I follow "Create new"
  And I fill in "project_name" with "My project"
  And I fill in "project_start_date" with "2010-01-01"
  And I fill in "project_end_date" with "2010-01-02"
  And I press "Create"
  And I should see "My project"
  When I follow "Edit"
  And I fill in "project_name" with "My new project"
  And I press "Update"
  Then I should see "My new project"
  When I will confirm a js popup
  And I follow "Delete"
  Then I should not see "My new project"

@projects
Scenario: Search projects
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the projects page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@projects @javascript
Scenario: Search projects (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the projects page for "Req1"
  When I follow "Search"
  And I fill in "s_q" with "project 1"
  And I press "Search"
  Then I should see "project 1"
  And I should not see "project 2"

@projects
Scenario: Sort projects
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the projects page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Name"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Name"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Description"
  Then I should see "description 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "description 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Description"
  Then I should see "description 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "description 2" within "#main_table tbody tr:nth-child(2)"

@projects @javascript
Scenario: Sort projects (with JS)
  Given a basic org + reporter profile, with data response, signed in
  And the following projects
    | name         | description    | request | organization |
    | project 1    | description 1  | Req1    | UNDP         |
    | project 2    | description 2  | Req1    | UNDP         |
  When I go to the projects page for "Req1"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Name"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Name"
  Then I should see "project 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "project 2" within "#main_table tbody tr:nth-child(2)"
  When I follow "Description"
  Then I should see "description 2" within "#main_table tbody tr:nth-child(1)"
  Then I should see "description 1" within "#main_table tbody tr:nth-child(2)"
  When I follow "Description"
  Then I should see "description 1" within "#main_table tbody tr:nth-child(1)"
  Then I should see "description 2" within "#main_table tbody tr:nth-child(2)"

@projects
Scenario Outline: Edit project dates, see feedback messages for start and end dates
  Given a basic org + reporter profile, with data response, signed in
  When I go to the projects page for "Req1"
  And I follow "Create new"
  And I fill in "project_name" with "Some Project"
  And I fill in "project_start_date" with "<start_date>"
  And I fill in "project_end_date" with "<end_date>"
  And I press "Create"
  Then I should see "<message>"
  And I should see "<specific_message>" within "<within>"
  
  Examples:
    | start_date | end_date   | message                          | specific_message                      | within                    |
    | 2010-01-01 | 2010-01-02 | Project was successfully created | Some Project                          | table                     |
    |            | 2010-01-02 | Create new project               | is an invalid date                    | #project_start_date_input |
    | 2010-05-05 | 2010-01-02 | Create new project               | Start date must come before End date. | .form_box                 |

@projects
Scenario Outline: Edit project dates, see feedback messages for Total budget and Total budget GOR
  Given a basic org + reporter profile, with data response, signed in
  When I go to the projects page for "Req1"
  And I follow "Create new"
  And I fill in "project_name" with "Some Project"
  And I fill in "project_start_date" with "2010-01-01"
  And I fill in "project_end_date" with "2010-01-02"
  And I fill in "project_entire_budget" with "<entire_budget>"
  And I fill in "project_budget" with "<budget_gor>"
  And I press "Create"
  Then I should see "<message>"
  And I should see "<specific_message>"
  
  Examples:
    | entire_budget  | budget_gor | message                           | specific_message                                                     |
    | 900            | 800        | Project was successfully created. | Some Project                                                         |
    | 900            | 900        | Project was successfully created. | Some Project                                                         |
    | 900            | 1000       | Create new project                | Total Budget must be less than or equal to Total Budget GOR FY 10-11 |
