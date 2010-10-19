Feature: Reporter can see comments
  In order to help reporters see missed areas
  As a reporter
  I want to be able to see comments that reviewers have made

#  - a comment feed page
#  - that shows 1 or 2 with a link to more
Scenario: See comment excerpts on dashboard
  Given a basic org + reporter profile, with data response, signed in
  Given the following projects 
    | name                 | request | organization |
   | TB Treatment Project | Req1    | UNDP          | 
  Given the following comments 
    | project              | title   | comment |
    | TB Treatment Project | title1  | the first comment |
  When I follow "Dashboard"
  Then I should see "Recent Comments"
  And I should see "title1"
  And I should see "on Project: "
  And I should see "TB Treatment Project"
  
@run
Scenario: See full comment listing
  Given a basic org + reporter profile, with data response, signed in
  Given the following projects 
    | name                 | request | organization |
   | TB Treatment Project | Req1    | UNDP          | 
  Given the following comments 
    | project              | title   | comment |
    | TB Treatment Project | title1  | the first comment |
    | TB Treatment Project | title2  | the second comment |
  When I follow "Dashboard"
  And I follow "all comments"
  Then I should be on the comment listing page
  
Scenario: See full comment detail

Scenario: respond to comment



