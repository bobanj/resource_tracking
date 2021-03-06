Feature: Admin can approve a code breakdown for each activity
  In order to increase the quality of information reported
  As an admin
  I want to be able to approve activity splits via the admin data response review screen

Background:
  Given an organization exists with name: "UNAIDS"
  And a data_request exists with title: "Req1", requesting_organization: the organization
  And an organization exists with name: "WHO"
  And a data_response exists with data_request: the data_request, organization: the organization
  And a project exists with name: "TB Treatment Project", data_response: the data_response
  And an activity exists with name: "TB Drugs procurement", data_response: the data_response
  And the project is one of the activity's projects
  And a budget coding code_name: "Delivering Services, Implementing Programs, Conducting Research", activity: "the activity", amount: "1000"

# Textmate syntax highlighting FTL! '

@admin_approve_activity @javascript
Scenario: See a budget coding breakdown
  Given I am signed in as an admin
  When I go to the admin review data response page for organization "WHO", request "Req1"
  And wait a few moments
  Then I should see "Delivering Services, Implementing Programs, Conducting Research"
  And I should see "1,000.00"

# NB: this scenario will only work for 1 activity, 1 classification
@admin_approve_activity @javascript
Scenario: Approve a budget coding breakdown
  Given I am signed in as an admin
  When I go to the admin review data response page for organization "WHO", request "Req1"
  And I click element "#project_details"
  And I click element ".project .descr"
  And I click element "#projects .activity_details"
  And I click element "#projects .activity .descr"
  Then I should see "Approved?"
  When I check "approve_activity"
  And wait a few moments
  And I go to the admin review data response page for organization "WHO", request "Req1"
  Then the "approve_activity" checkbox should be checked
