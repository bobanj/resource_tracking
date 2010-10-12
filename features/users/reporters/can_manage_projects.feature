Feature: In order to reduce costs
  As a reporter
  I want to be able to manage my projects

@projects
Scenario: Browse to project edit page
  Given a basic org + reporter profile, with data response, signed in
  When I follow "My Data"
  And I follow "Projects"
  Then I should be on the projects page for "Req1"
  And I should see "Projects" within "div#main"

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
