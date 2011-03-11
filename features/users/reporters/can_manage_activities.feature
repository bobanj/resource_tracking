Feature: Reporter can manage activities
  In order to track information
  As a reporter
  I want to be able to manage activities

Background:
  Given an organization exists with name: "organization1"
  And a data_request exists with title: "data_request1"
  And an organization exists with name: "organization2"
  And a data_response exists with data_request: the data_request, organization: the organization
  And a reporter exists with username: "reporter", organization: the organization
  And a project exists with name: "project1", data_response: the data_response
  And I am signed in as "reporter"

Scenario: Reporter can CRUD activities
  When I follow "data_request1"
  And I follow "Activities"
  And I follow "Create Activity"
  And I fill in "Name" with "Activity1"
  And I fill in "Description" with "Activity1 description"
  And I fill in "Start date" with "2011-01-01"
  And I fill in "End date" with "2011-12-01"
  And I select "project1" from "Project"
  And I press "Create New Activity"
  Then I should see "Activity was successfully created"
  And I should see "Activity1"
  And I should see "Activity1 description"

  When I follow "Edit"
  And I fill in "Name" with "Activity2"
  And I fill in "Description" with "Activity2 description"
  And I press "Update Activity"
  Then I should see "Activity was successfully updated"
  Then I should see "Activity2"
  And I should see "Activity2 description"
  And I should not see "Activity1"

  When I follow "Delete"
  Then I should see "Activity was successfully destroyed"
  And I should not see "Activity1"
  And I should not see "Activity2"

Scenario Outline: Reporter can CRUD activities and see errors
  When I follow "data_request1"
  And I follow "Activities"
  And I follow "Create Activity"
  And I fill in "Name" with "<name>"
  And I fill in "Start date" with "<start_date>"
  And I fill in "End date" with "<end_date>"
  And I select "<project>" from "Project"
  And I press "Create New Activity"
  Then I should see "Oops, we couldn't save your changes."
  And I should see "<message>"

  Examples:
     | name | start_date | end_date   | project  | message                       |
     |      | 2011-01-01 | 2011-12-01 | project1 | Name can't be blank           |
     | a1   |            | 2011-12-01 | project1 | Start date is an invalid date |
     | a1   | 2011-01-01 |            | project1 | End date is an invalid date   |
     | a1   | 2011-01-01 | 2011-12-01 |          | Project can't be blank        |

Scenario: Reporter can file upload activities
  When I follow "data_request1"
  And I follow "Activities"
  When I attach the file "spec/fixtures/activities.csv" to "File"
  And I press "Upload and Import"
  Then I should see "Created 4 of 4 activities successfully"
  And I should see "a1"
  And I should see "a2"
  And I should see "a3"
  And I should see "a4"

Scenario: Reporter can see error if no csv file is not attached for upload
  When I follow "data_request1"
  And I follow "Activities"
  And I press "Upload and Import"
  Then I should see "Please select a file to upload"

Scenario: Reporter can see error when invalid csv file is attached for upload
  When I follow "data_request1"
  And I follow "Activities"
  When I attach the file "spec/fixtures/invalid.csv" to "File"
  And I press "Upload and Import"
  Then I should see "Wrong fields mapping. Please download the CSV template"
