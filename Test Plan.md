Student Name: Marina Skegro

Degree and Major: Bachelor of Science in Computer Science

Project Advisor Name: Professor Julie Henderson

Expected Graduation Date: May 2026

*  
*

# Table of Contents {#table-of-contents .TOC-Heading}

[1 Introduction [3](#introduction)](#introduction)

[1.1 Purpose [3](#purpose)](#purpose)

[1.2 Project Overview [3](#project-overview)](#project-overview)

[2 Scope [3](#scope)](#scope)

[2.1 In-Scope [3](#in-scope)](#in-scope)

[2.2 Out-of-Scope [3](#out-of-scope)](#out-of-scope)

[3 Testing Strategy [3](#testing-strategy)](#testing-strategy)

[3.1 Test Objectives [3](#test-objectives)](#test-objectives)

[3.2 Test Assumptions [3](#test-assumptions)](#test-assumptions)

[3.3 Data Approach [3](#data-approach)](#data-approach)

[3.4 Level of Testing [3](#level-of-testing)](#level-of-testing)

[3.5 Unit Testing [4](#unit-testing)](#unit-testing)

[3.6 Functional Testing [4](#functional-testing)](#functional-testing)

[3.7 User Acceptance Testing
[4](#user-acceptance-testing)](#user-acceptance-testing)

[3.8 Regression Testing [5](#regression-testing)](#regression-testing)

[4 Execution Strategy [5](#execution-strategy)](#execution-strategy)

[4.1 Entry Criteria [5](#entry-criteria)](#entry-criteria)

[4.2 Exit criteria [6](#exit-criteria)](#exit-criteria)

[4.3 Validation and Defect Management
[6](#validation-and-defect-management)](#validation-and-defect-management)

[5 Environment Requirements
[7](#environment-requirements)](#environment-requirements)

[5.1 Test Environments [7](#test-environments)](#test-environments)

[6 Significantly Impacted Division/College/Department
[7](#_Toc515524414)](#_Toc515524414)

[7 Dependencies [7](#dependencies)](#dependencies)

# Introduction

##  Purpose {#purpose}

This test plan defines the comprehensive testing approach for the
Gamified Habit Tracker mobile application. It ensures all functional
requirements performance criteria, security requirements, and usability
standards are validated before deployment.

##  Project Overview {#project-overview}

The Gamified Habit Tracker is a cross-platform mobile app developed
using Flutter and Firebase. The app allows users to create, monitor, and
maintain habits while earning XP, badges, and rewards through
gamification techniques. It focuses on improving user motivation and
engagement through interactive and rewarding habit tracking.

#  Scope {#scope}

##  In-Scope {#in-scope}

This testing plan includes all major functional components of the app,
including authentication, habit creation, XP and streak systems,
notifications, and analytics. The tests will focus on ensuring correct
functionality, usability, data synchronization, and performance.

##  Out-of-Scope {#out-of-scope}

The scope excludes third-party integrations not used in the current
release, advanced AI features, and large-scale user load testing.

#  Testing Strategy {#testing-strategy}

##  Test Objectives {#test-objectives}

To verify that all features of the Gamified Habit Tracker function as
expected and provide a seamless user experience. Objectives include
validating functionality, usability, data accuracy, security, and
performance.

##  Test Assumptions {#test-assumptions}

It is assumed that the Firebase backend, APIs, and dependencies are
stable and functional. All testing environments mirror the production
configuration as closely as possible.

##  Data Approach {#data-approach}

Test data will be generated to simulate real user habits and behavior.
Data will include multiple user profiles, varied habit types, and XP
progression patterns.

##  Level of Testing {#level-of-testing}

Testing will be conducted at multiple levels: unit testing, functional
testing, user acceptance testing (UAT), and regression testing.

| **Test Type**                        | **Description**                                                                  | **Responsible Parties** |
|--------------------------------------|----------------------------------------------------------------------------------|-------------------------|
| Unit / Functional / UAT / Regression | All levels of testing to validate app performance, functionality, and usability. | Marina Skegro           |

##  Unit Testing {#unit-testing}

Unit testing will validate the smallest functional components, such as
XP calculation, streak logic, and habit creation. Automated unit tests
will be implemented using Flutter's test framework.

| **Tester's Name** | **Department/ Area** | **Role**                      |
|-------------------|----------------------|-------------------------------|
| Marina Skegro     | Computer Science     | Test Manager / Lead / Analyst |

##  Functional Testing {#functional-testing}

Functional testing ensures that all app features, including
authentication, habit tracking, notifications, and analytics, perform
according to requirements. Manual and automated testing will be used to
verify user interactions and data flow.

**3.6 Habit Creation and Customization Testing (F-01)**

This section provides detailed test cases for habit creation and
customization, which form the core functionality of the application.

**Test Case 3.6.1: Create Habit with Name, Description, and Recurrence
Settings**

Priority: HIGH  
Related Requirements: F-01 (Users can create and customize habits with
names, descriptions, and recurrence settings)

Fit Criteria: The user should be able to create at least five habits
during a session

Preconditions:

- User is logged in successfully via Google or Email authentication
  (S-02)

- Dashboard screen is displayed

- Firebase Firestore connection is active

Test Steps:

1.  Locate and tap the \'+\' floating action button on the dashboard

2.  Verify habit creation screen opens

3.  Enter habit name: \'Morning Exercise\'

4.  Enter description: \'Run for 30 minutes every morning\'

5.  Select recurrence setting: \'Daily\'

6.  Tap \'Save\' button

7.  Verify habit appears in dashboard

Expected Results:

| **Expected Result**                                                    | **Pass/Fail** |
|------------------------------------------------------------------------|---------------|
| Habit creation screen opens immediately upon tapping \'+\'             |               |
| All input fields (name, description, recurrence) accept data correctly |               |
| \'Save\' button becomes enabled when name field is filled              |               |
| Habit saves to Firestore successfully                                  |               |
| User returns to dashboard automatically                                |               |
| New habit \'Morning Exercise\' appears in habit list                   |               |
| Habit displays with correct recurrence setting (Daily)                 |               |
| Success message displays: \'Habit created successfully!\'              |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.6.2: Create Multiple Habits in One Session**

Priority: HIGH  
Related Requirements: F-01  
Fit Criteria: The user should be able to create at least five habits
during a session

Test Steps:

1.  Create habit \#1: \'Drink Water\' - Daily recurrence

2.  Create habit \#2: \'Read Books\' - Daily recurrence

3.  Create habit \#3: \'Yoga Practice\' - Weekly recurrence (Mondays,
    Wednesdays)

4.  Create habit \#4: \'Meditation\' - Daily recurrence

5.  Create habit \#5: \'Meal Prep\' - Weekly recurrence (Sundays)

6.  Verify all 5 habits appear in dashboard

Expected Results:

| **Expected Result**                                                       | **Pass/Fail** |
|---------------------------------------------------------------------------|---------------|
| All 5 habits created successfully without errors                          |               |
| Each habit saves to Firestore with correct data                           |               |
| Dashboard displays all 5 habits                                           |               |
| Daily recurrence habits show \"Every day\" indicator                      |               |
| Weekly recurrence habits show specific days                               |               |
| No performance degradation when creating multiple habits                  |               |
| User able to create 5+ habits in single session (meets F-01 fit criteria) |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.6.3: Customize Habit with All Available Options**

Priority: HIGH  
Related Requirements: F-01

Test Steps:

1.  Create new habit with following customizations:

    - Name: \'Evening Yoga Session\'

    - Description: \'30 minutes of relaxing yoga and stretching before
      bed\'

    - Recurrence: Custom (Monday, Wednesday, Friday)

2.  Save habit

3.  Verify all customizations are preserved

Expected Results:

| **Expected Result**                                               | **Pass/Fail** |
|-------------------------------------------------------------------|---------------|
| All three elements (name, description, recurrence) save correctly |               |
| Habit displays with full description when viewed                  |               |
| Custom recurrence shows only selected days (Mon/Wed/Fri)          |               |
| Habit appears on dashboard only on specified days                 |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.7: Edit Existing Habit Customizations**

Priority: HIGH  
Related Requirements: F-01  
Dependencies: Habit must exist first

Test Steps:

1.  Select existing habit \'Morning Exercise\'

2.  Edit name to \'Morning Jog\'

3.  Edit description to \'Jog for 30 minutes around the park\'

4.  Change recurrence from \'Daily\' to \'Weekdays only\'

5.  Save changes

Expected Results:

| **Expected Result**                              | **Pass/Fail** |
|--------------------------------------------------|---------------|
| Edit screen opens with current values pre-filled |               |
| Changes save successfully to Firestore           |               |
| Habit updates in list immediately                |               |
| New name \'Morning Jog\' displays correctly      |               |
| Recurrence updated to weekdays only              |               |
| Historical data (streaks, XP) preserved (P-07)   |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.7.1: Delete Habit**

Priority: HIGH  
Related Requirements: F-01

Test Steps:

1.  Long-press on habit \'Evening Yoga Session\'

2.  Select \'Delete\' option

3.  Confirm deletion in 

Expected Results:

| **Expected Result**                                                          | **Pass/Fail** |
|------------------------------------------------------------------------------|---------------|
| Confirmation dialog appears: \"Are you sure you want to delete this habit?\" |               |
| On \'Delete\': Habit removed from dashboard                                  |               |
| On \'Delete\': Habit removed from Firestore                                  |               |
| On \'Cancel\': Nothing changes, habit remains                                |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.8 Experience Points (XP) System Testing (F-02)**

The XP system motivates users through gamification by awarding points
for habit completion.

**Test Case 3.8.1: XP Award Immediately After Habit Completion**

Priority: CRITICAL  
Related Requirements: F-02 (Users earn experience points (XP) for
completing habits)  
Fit Criteria: XP should update immediately after habit completion  
Dependencies: F-01 (Requires existing habit)

Preconditions:

- User has habit \'Morning Jog\' created

- User\'s current total XP = 0

- Habit has not been completed today

Test Steps:

1.  Navigate to dashboard

2.  Note current total XP

3.  Tap checkbox to mark \'Morning Jog\' as complete

4.  Observe XP update timing

5.  Check total XP value

Expected Results:

| **Expected Result**                                               | **Pass/Fail** |
|-------------------------------------------------------------------|---------------|
| Checkbox shows checked state immediately                          |               |
| XP updates IMMEDIATELY after completion (meets F-02 fit criteria) |               |
| XP gain animation displays (implemented per LF-02)                |               |
| User\'s total XP increases by base amount (e.g., 10 XP)           |               |
| XP displays in profile/dashboard                                  |               |
| XP saved to Firestore user document                               |               |

Timing Verification:

- XP must update immediately (\< 1 second) to meet F-02 fit criteria

- Visual feedback should be instant

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.8.2 XP Calculation Accuracy**

Priority: HIGH  
Related Requirements: F-02, P-07 (Habit streaks and XP calculations
should be accurate)  
Fit Criteria: Test data consistency by completing and undoing habits
multiple times

Test Steps:

1.  Note starting XP: 0

2.  Complete \'Morning Jog\' - Expected: +10 XP (Total: 10)

3.  Complete \'Drink Water\' - Expected: +10 XP (Total: 20)

4.  Complete \'Meditation\' - Expected: +10 XP (Total: 30)

5.  Uncheck \'Meditation\' - Expected: -10 XP (Total: 20)

6.  Re-check \'Meditation\' - Expected: +10 XP (Total: 30)

7.  Verify final total

Expected Results:

| **Expected Result**                                                   | **Pass/Fail** |
|-----------------------------------------------------------------------|---------------|
| Each completion adds correct XP amount                                |               |
| Unchecking removes XP correctly                                       |               |
| Re-checking adds XP back                                              |               |
| Final XP calculation is accurate: 30 XP                               |               |
| XP calculations remain consistent after multiple changes (meets P-07) |               |
| No rounding errors or calculation bugs                                |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.8.3: XP with Streak Bonus**

Priority: HIGH  
Related Requirements: F-02, F-03  
Dependencies: F-03 (Streak tracking)

Preconditions:

- Habit \'Morning Jog\' has 7-day active streak

- User understands streak bonus calculation

Test Steps:

1.  Complete habit with 7-day streak

2.  Observe XP awarded

3.  Verify bonus calculation

Expected Results:

| **Expected Result**                    | **Pass/Fail** |
|----------------------------------------|---------------|
| Base XP awarded (10 points)            |               |
| Streak bonus applied for 7+ day streak |               |
| Total XP reflects both base + bonus    |               |
| Calculation accurate (meets P-07)      |               |
| XP updates immediately (meets F-02)    |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.9 Streak Tracking System Testing (F-03)**

Streak tracking encourages consistent habit formation by displaying
consecutive completion days.

**Test Case 3.9.1: Display Streak Count for Each Habit**

Priority: HIGH  
Related Requirements: F-03 (Users can track their habit streaks)  
Fit Criteria: The app should display streak count for each habit  
Dependencies: F-01 (Requires existing habits)

Preconditions:

- User has habit \'Morning Jog\' with some completion history

Test Steps:

1.  View habit list on dashboard

2.  Locate \'Morning Jog\' habit

3.  Check for streak counter display

4.  Note streak number shown

Expected Results:

| **Expected Result**                                           | **Pass/Fail** |
|---------------------------------------------------------------|---------------|
| Streak count visible on habit card (meets F-03 fit criteria)  |               |
| Streak displays as number (e.g., \"5-day streak\" or \"🔥5\") |               |
| Streak is correctly displayed                                 |               |
| Streak count is accurate based on completion history          |               |
| Each habit shows its own individual streak                    |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.9.2: Streak Increments on Consecutive Completion**

Priority: HIGH  
Related Requirements: F-03, P-07

Preconditions:

- Habit \'Morning Jog\' completed yesterday

- Current streak = 5 days

Test Steps:

1.  Note current streak: 5 days

2.  Complete \'Morning Jog\' today

3.  Check updated streak count

Expected Results:

| **Expected Result**                                                          | **Pass/Fail** |
|------------------------------------------------------------------------------|---------------|
| Streak increments from 5 to 6                                                |               |
| Streak update is immediate                                                   |               |
| Streak calculation is accurate (consecutive days counted correctly per P-07) |               |
| Streak displayed correctly for this habit (F-03)                             |               |
| Last completion date updates to today                                        |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.9.3: Streak Resets After Missed Day**

Priority: HIGH  
Related Requirements: F-03, P-07

Preconditions:

- Habit \'Meditation\' last completed 2 days ago

- Current streak = 10 days

Test Steps:

1.  Note current streak: 10 days

2.  Complete \'Meditation\' today (missed yesterday)

3.  Observe streak counter

Expected Results:

| **Expected Result**                                                       | **Pass/Fail** |
|---------------------------------------------------------------------------|---------------|
| Streak resets to 1 day (fresh start)                                      |               |
| Previous streak of 10 days can be stored as \"longest streak\" (optional) |               |
| Reset calculation is accurate (P-07)                                      |               |
| New streak count displays correctly (F-03)                                |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.9.4: Streak Accuracy with Multiple Habits**

Priority: HIGH  
Related Requirements: F-03, P-07  
Fit Criteria: Test data consistency by completing and undoing habits
multiple times

Test Steps:

1.  Complete \'Morning Jog\' (Streak: 1)

2.  Complete \'Drink Water\' (Streak: 1)

3.  Complete \'Meditation\' (Streak: 1)

4.  Next day: Complete all three habits again

5.  Uncheck \'Meditation\', then re-check it

6.  Verify all streak counts

Expected Results:

| **Expected Result**                                | **Pass/Fail** |
|----------------------------------------------------|---------------|
| Each habit maintains independent streak counter    |               |
| All three habits show Streak: 2 after day 2        |               |
| Unchecking and re-checking doesn\'t affect streak  |               |
| Streak calculations accurate for all habits (P-07) |               |
| All streaks display correctly (F-03)               |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.10 Achievement Badge System Testing (F-04)**

Achievement badges encourage long-term habit tracking by recognizing
milestones.

**Test Case 3.10.1: Achievement Appears in Profile When Unlocked**

Priority: MEDIUM  
Related Requirements: F-04 (Users can unlock achievement badges upon
reaching milestones)  
Fit Criteria: Achievements should appear in the user profile when
unlocked  
Dependencies: F-03 (Streak tracking for milestone achievements)

Preconditions:

- User has no achievements unlocked

- User profile screen accessible

Test Steps:

1.  Complete habit for 7 consecutive days to reach milestone

2.  Check if achievement unlocks

3.  Navigate to user profile

4.  Verify achievement display

Expected Results:

| **Expected Result**                                           | **Pass/Fail** |
|---------------------------------------------------------------|---------------|
| Achievement unlocks upon reaching 7-day streak milestone      |               |
| Achievement appears in user profile (meets F-04 fit criteria) |               |
| Achievement displays with badge icon                          |               |
| Achievement shows unlock date                                 |               |
| Achievement saved to Firestore                                |               |
| Notification alerts user of achievement (if F-06 implemented) |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.10.2: Multiple Achievement Milestones**

Priority: MEDIUM  
Related Requirements: F-04

Test Steps:

1.  Unlock \"Week Warrior\" achievement (7-day streak)

2.  Navigate to profile, verify it appears

3.  Continue to unlock \"Month Master\" achievement (30-day streak)

4.  Navigate to profile, verify both appear

5.  Unlock \"XP Champion\" achievement (1000 total XP)

6.  Verify all three achievements in profile

Expected Results:

| **Expected Result**                                | **Pass/Fail** |
|----------------------------------------------------|---------------|
| All unlocked achievements appear in profile        |               |
| Achievements listed chronologically or by category |               |
| Each achievement shows unlock date                 |               |
| Profile displays total achievement count           |               |
| Locked achievements shown in grayed-out state      |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.10.3: Achievement Unlock Does Not Affect Other Data**

Priority: MEDIUM  
Related Requirements: F-04, P-07

Test Steps:

1.  Track current XP and streak counts

2.  Unlock achievement

3.  Verify XP and streaks unchanged

Expected Results:

| **Expected Result**                                  | **Pass/Fail** |
|------------------------------------------------------|---------------|
| Achievement unlock process doesn\'t modify XP totals |               |
| Achievement unlock doesn\'t affect streak counts     |               |
| All data remains accurate (P-07)                     |               |
| Only achievement status changes                      |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.11 Progress Analytics Testing (F-05)**

Analytics visualize progress to motivate habit consistency through
graphs and trends.

**Test Case 3.11.1: Display Simple Progress Graphs**

Priority: MEDIUM  
Related Requirements: F-05 (Users can view habit progress analytics)  
Fit Criteria: Show simple progress graphs, such as weekly or daily
trends  
Dependencies: F-01 (Requires habit data)

Preconditions:

- User has completed habits over multiple days

- Analytics screen accessible from dashboard

Test Steps:

1.  Navigate to analytics/progress screen

2.  Verify graph displays

3.  Check for weekly trend graph

4.  Check for daily trend graph

Expected Results:

| **Expected Result**                                                 | **Pass/Fail** |
|---------------------------------------------------------------------|---------------|
| Analytics screen displays progress graphs (meets F-05 fit criteria) |               |
| Weekly trends graph visible showing habit completions               |               |
| Daily trends visible                                                |               |
| XP progress over time displayed (weekly/monthly)                    |               |
| Streak history graph shown                                          |               |
| Graphs are simple and easy to understand                            |               |
| Graph data reflects actual completion history                       |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.11.2: Analytics Accuracy**

Priority: MEDIUM  
Related Requirements: F-05, P-07

Test Steps:

1.  Complete 3 habits on Day 1

2.  Complete 5 habits on Day 2

3.  Complete 2 habits on Day 3

4.  View analytics screen

5.  Verify graph data matches actual completions

Expected Results:

| **Expected Result**                   | **Pass/Fail** |
|---------------------------------------|---------------|
| Day 1 shows 3 completions in graph    |               |
| Day 2 shows 5 completions in graph    |               |
| Day 3 shows 2 completions in graph    |               |
| Data visualization is accurate (P-07) |               |
| Weekly totals calculate correctly     |               |
| Monthly totals accurate               |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.11.3: Empty State Analytics**

Priority: LOW  
Related Requirements: F-05

Preconditions:

- New user with no habit completion history

Test Steps:

1.  Navigate to analytics screen

2.  Observe display

Expected Results:

| **Expected Result**                                                             | **Pass/Fail** |
|---------------------------------------------------------------------------------|---------------|
| Analytics screen doesn\'t crash with no data                                    |               |
| Empty state message displays: \"Start completing habits to see your progress!\" |               |
| Empty graphs shown or placeholder message                                       |               |
| No errors or broken visualizations                                              |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.12 Notification and Reminder System Testing (F-06)**

Notifications improve consistency by reminding users to complete habits
at scheduled times.

**Test Case 3.12.1: Notification Triggers at Set Time**

Priority: LOW  
Related Requirements: F-06 (Users can receive habit reminders via
notifications)  
Fit Criteria: The notification should trigger at the set time, if they
are enabled  
Dependencies: F-01 (Requires habit with reminder)

Preconditions:

- User has enabled notifications in device settings

- Habit \'Morning Meditation\' has reminder set for 7:00 AM

Test Steps:

1.  Set reminder for habit at specific time (7:00 AM)

2.  Wait for scheduled time

3.  Verify notification appears

Expected Results:

| **Expected Result**                                        | **Pass/Fail** |
|------------------------------------------------------------|---------------|
| Notification triggers at 7:00 AM (meets F-06 fit criteria) |               |
| Notification appears within ±1 minute of set time          |               |
| Notification only appears if enabled                       |               |
| Notification includes habit name                           |               |
| Tapping notification opens app to habit                    |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.12.2: Enable/Disable Notifications**

Priority: LOW  
Related Requirements: F-06

Test Steps:

1.  Create habit with reminder enabled

2.  Verify notification scheduled

3.  Disable notifications in settings

4.  Verify notification does not trigger

5.  Re-enable notifications

6.  Verify notification triggers again

Expected Results:

| **Expected Result**                             | **Pass/Fail** |
|-------------------------------------------------|---------------|
| When enabled, notifications trigger at set time |               |
| When disabled, notifications do not trigger     |               |
| Toggle setting works correctly                  |               |
| Preference saved to Firestore                   |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.12.3: Offline Reminder Support**

Priority: LOW  
Related Requirements: F-06

Preconditions:

- Flutter Local Notifications implemented for offline reminders

- Device has no internet connection

Test Steps:

1.  Set habit reminder

2.  Disable internet/enable airplane mode

3.  Wait for reminder time

4.  Verify local notification triggers

Expected Results:

| **Expected Result**                      | **Pass/Fail** |
|------------------------------------------|---------------|
| Local notification triggers even offline |               |
| Uses Flutter Local Notifications package |               |
| Notification content accurate            |               |
| Tapping opens app when back online       |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**3.13 Data Synchronization Testing (F-07)**

Cloud-based storage ensures data accessibility across multiple devices.

**Test Case 3.13.1: Sync Data Across Multiple Devices**

Priority: HIGH  
Related Requirements: F-07 (Users can sync data across multiple
devices)  
Fit  Criteria: Data should sync on a different logged-in device  
Dependencies: None

Preconditions:

- Same user account logged in on Device A and Device B

- Both devices have internet connection

Test Steps:

1.  On Device A: Create habit \'Test Sync Habit\'

2.  On Device A: Complete the habit

3.  On Device B: Open app or refresh

4.  Verify habit appears on Device B

Expected Results:

| **Expected Result**                                                     | **Pass/Fail** |
|-------------------------------------------------------------------------|---------------|
| Habit created on Device A appears on Device B (meets F-07 fit criteria) |               |
| Completion status syncs to Device B                                     |               |
| XP total syncs correctly                                                |               |
| Streak count matches across devices                                     |               |
| All habit data consistent between devices                               |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.13.2: Automatic Sync When Network Restored**

Priority: HIGH  
Related Requirements: F-07, P-03 (The app should automatically sync data
when network connectivity is restored)  
Fit Criteria: Sync data once the network is available after the
connection is restored

Preconditions:

- User has completed habits offline

Test Steps:

1.  Disable internet connection on device

2.  Complete 3 habits while offline

3.  Create 1 new habit while offline

4.  Re-enable internet connection

5.  Wait for sync to occur

6.  Check second device for updates

Expected Results:

| **Expected Result**                                                        | **Pass/Fail** |
|----------------------------------------------------------------------------|---------------|
| When network restored, sync occurs automatically (meets P-03 fit criteria) |               |
| Offline changes queue locally                                              |               |
| All 3 completed habits sync to cloud                                       |               |
| New habit appears in Firestore                                             |               |
| Second device receives updates                                             |               |
| No data loss during offline period                                         |               |
| Sync happens once network available (P-03)                                 |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 3.13.4: Sync Data Integrity**

Priority: HIGH  
Related Requirements: F-07, P-07

Test Steps:

1.  On Device A: Complete \'Morning Jog\' (XP: +10)

2.  On Device A: Complete \'Drink Water\' (XP: +10)

3.  Total XP on Device A: 20

4.  On Device B: Login and sync

5.  Verify XP total and habit completions

Expected Results:

| **Expected Result**                           | **Pass/Fail** |
|-----------------------------------------------|---------------|
| Device B shows same XP total (20) as Device A |               |
| Both habits show as completed on Device B     |               |
| Streak counts identical on both devices       |               |
| Achievement unlocks synced                    |               |
| Data integrity maintained (P-07)              |               |
| No data corruption during sync                |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**4. Performance Testing**

**4.1 App Launch and Load Time Testing (P-01)**

**Test Case 4.1.1: Dashboard Loads Within 3-5 Seconds**

Priority: HIGH  
Related Requirements: P-01 (The app should load the main dashboard
within 3-5 seconds)  
Fit Criteria: Measure load time with Firebase profiling tools

Test Environment:

- Mid-range iOS/Android device

- App not in memory (force-closed)

- Internet connection available

Test Steps:

1.  Force-close app completely

2.  Start Firebase Performance Monitoring

3.  Tap app icon

4.  Measure time until dashboard fully loaded and interactive

5.  Record load time

6.  Repeat test 10 times

7.  Calculate average load time

Expected Results:

| **Expected Result**                                          | **Pass/Fail** |
|--------------------------------------------------------------|---------------|
| Dashboard loads within 3-5 seconds (meets P-01 fit criteria) |               |
| Firebase profiling tools confirm measurement                 |               |
| Average load time across 10 tests ≤ 5 seconds                |               |
| 90th percentile load time ≤ 5 seconds                        |               |
| No crashes during launch                                     |               |

Measurement Method:

- Use Firebase Performance Monitoring as specified in P-01

- Record cold start time

- Document average, median, and 90th percentile

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**4.2 Scalability and Data Handling (P-02, P-06)**

**Test Case 4.2.1: Handle Increasing Data Without Performance
Degradation**

Priority: HIGH  
Related Requirements: P-02 (The app should handle an increasing amount
of data and user activities without performance degradation)  
Fit Criteria: Performance tests should show that data processing,
syncing, and UI responsiveness remain stable

Test Data:

- Test with 10, 25, 50 habits

- Multiple weeks of completion history

Test Steps:

1.  Create 10 habits, complete them for 1 week

2.  Test dashboard load time and responsiveness

3.  Increase to 25 habits, complete for 2 weeks

4.  Re-test performance metrics

5.  Increase to 50 habits, complete for 4 weeks

6.  Final performance test

Expected Results:

| **Expected Result**                                              | **Pass/Fail** |
|------------------------------------------------------------------|---------------|
| Data processing remains stable with increasing data (meets P-02) |               |
| Syncing performance stays consistent                             |               |
| UI remains responsive at all data volumes                        |               |
| Dashboard scrolling smooth with 50 habits                        |               |
| No lagging or glitching                                          |               |
| Performance tests show stability (P-02 fit criteria)             |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 4.2.2: Support 50 Habits Without Slowdown**

Priority: MEDIUM  
Related Requirements: P-06 (The app should support up to 50 stored
habits per user without slowing down)  
Fit Criteria: Test response time while interacting with 50 habits

Test Steps:

1.  Create test account with exactly 50 habits

2.  Load dashboard and measure time

3.  Scroll through all 50 habits

4.  Select and complete 5 habits

5.  Measure response times for each action

Expected Results:

| **Expected Result**                                           | **Pass/Fail** |
|---------------------------------------------------------------|---------------|
| App supports 50 habits successfully (meets P-06)              |               |
| Dashboard loads all 50 habits without slowdown                |               |
| Scrolling remains smooth                                      |               |
| Habit completion response time acceptable                     |               |
| No performance degradation with 50 habits (P-06 fit criteria) |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**4.3 Data Robustness Testing (P-03, P-08)**

**Test Case 4.3.1: No Crash or Data Corruption When Suddenly Closed**

Priority: HIGH  
Related Requirements: P-08 (The app should not crash or corrupt data
when suddenly closed)  
Fit Criteria: Simulate force-closing the app and check for saved state
and no corrupted data  
Dependencies: F-01, F-07

Test Steps:

1.  Create new habit \'Test Habit\'

2.  Complete the habit (gain XP)

3.  Immediately force-close app (swipe away from recent apps)

4.  Reopen app

5.  Check habit status and XP

Expected Results:

| **Expected Result**                               | **Pass/Fail** |
|---------------------------------------------------|---------------|
| App does not crash when force-closed (meets P-08) |               |
| Habit \'Test Habit\' still exists after reopen    |               |
| Completion status preserved                       |               |
| XP total accurate and not corrupted               |               |
| Saved state correct (meets P-08 fit criteria)     |               |
| No data corruption detected                       |               |
| User data remains safe (P-08)                     |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**4.4 Accuracy and Precision Testing (P-07)**

**Test Case 4.4.1: XP and Streak Calculations Are Accurate**

Priority: HIGH  
Related Requirements: P-07 (Habit streaks and XP calculations should be
accurate and updated correctly)  
Fit Criteria: Test data consistency by completing and undoing habits
multiple times  
Dependencies: F-02, F-03

Test Steps:

1.  Start with 0 XP, 0 streaks

2.  Complete habit Day 1 - Record XP and streak

3.  Complete habit Day 2 - Record XP and streak

4.  Skip Day 3 - Check if streak resets

5.  Complete habit Day 4 - Verify calculations

6.  Uncheck habit Day 4 - Verify XP deduction

7.  Re-check habit Day 4 - Verify XP re-addition

8.  Complete multiple times same day - Verify no duplicate XP

Expected Results:

| **Expected Result**                                                        | **Pass/Fail** |
|----------------------------------------------------------------------------|---------------|
| All XP calculations mathematically accurate                                |               |
| Streak increments correctly on consecutive days                            |               |
| Streak resets correctly after missed day                                   |               |
| Unchecking removes XP correctly                                            |               |
| Re-checking adds XP back correctly                                         |               |
| No duplicate XP on same-day multiple completions                           |               |
| Data remains consistent through multiple changes (meets P-07 fit criteria) |               |
| Accuracy maintained (P-07)                                                 |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**4.5 Reliability and Availability Testing (P-04)**

**Test Case 4.5.1: App Usable 95% of Time During Testing**

Priority: MEDIUM  
Related Requirements: P-04 (The app should be usable 95% of the time
during testing)  
Fit Criteria: Test uptime during repeated simulated sessions and check
for crashes or loading issues

Test Protocol:

- Duration: 1 week of testing

- Sessions: 10 usage sessions per day (70 total sessions)

- Each session: 5-10 minutes of normal usage

Test Steps:

1.  Launch app 10 times per day for 7 days

2.  Use app normally for 5-10 minutes each session

3.  Track successful sessions vs failed sessions

4.  Record any crashes or loading issues

5.  Calculate availability percentage

Expected Results:

| **Expected Result**                                              | **Pass/Fail** |
|------------------------------------------------------------------|---------------|
| App successfully launches and is usable \>= 95% of test sessions |               |
| Successful sessions \>= 67 out of 70 (95%)                       |               |
| Crashes occur in \< 5% of sessions                               |               |
| Loading issues minimal                                           |               |
| Meets P-04 fit criteria (95% uptime)                             |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**5. Security Testing**

**5.1 Authentication and Access Testing (S-02)**

**Test Case 5.1.1: Google Login Authentication**

Priority: HIGH  
Related Requirements: S-02 (Implement Google (and optionally Email)
login using Firebase)  
Fit Criteria: Users can log in using Google

Preconditions:

- Firebase Authentication configured

- Google Sign-In enabled in Firebase console

Test Steps:

1.  Open app (not logged in)

2.  Tap \'Sign in with Google\' button

3.  Select Google account

4.  Allow permissions

5.  Verify successful login

Expected Results:

| **Expected Result**                                                     | **Pass/Fail** |
|-------------------------------------------------------------------------|---------------|
| Google Sign-In button displays on login screen                          |               |
| Tapping button opens Google account selector                            |               |
| User can select account and allow permissions                           |               |
| Login succeeds and user directed to dashboard (meets S-02 fit criteria) |               |
| Firebase Authentication creates user session                            |               |
| User data accessible after login                                        |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 5.1.2: Email/Password Login **

Priority: MEDIUM  
Related Requirements: S-02

Test Steps:

1.  Tap \'Sign up with Email\' option

2.  Enter email and password

3.  Create account

4.  Logout

5.  Login again with same credentials

Expected Results:

| **Expected Result**                  | **Pass/Fail** |
|--------------------------------------|---------------|
| Email/password registration works    |               |
| Login with email/password successful |               |
| Authentication uses Firebase         |               |
| Optional implementation as per S-02  |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**5.2 Data Security and Privacy Testing (S-01, S-04, S-05)**

**Test Case 5.2.1: Only Authenticated Users Can Access Data**

Priority: HIGH  
Related Requirements: S-01 (Use Firebase with secure Firestore rules to
protect user data)  
Fit Criteria: Only authenticated users can access their data

Test Steps:

1.  Attempt to access Firestore data without logging in

2.  Verify access denied

3.  Log in as User A

4.  Access User A\'s habit data

5.  Attempt to access User B\'s habit data while logged in as User A

Expected Results:

| **Expected Result**                                             | **Pass/Fail** |
|-----------------------------------------------------------------|---------------|
| Unauthenticated access to Firestore is denied                   |               |
| User A can access only their own data (meets S-01 fit criteria) |               |
| User A cannot access User B\'s data                             |               |
| Firestore Security Rules enforce authentication                 |               |
| Only authenticated users access their data (S-01)               |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 5.2.2: Firestore Rules Restrict Unauthorized Access**

Priority: HIGH  
Related Requirements: S-05 (Use Firestore rules to restrict access to
authorized users only)  
Fit Criteria: Unauthorized access attempts return permission denied  
Dependencies: S-01

Test Steps:

1.  Log in as User A

2.  Try to read User B\'s habits collection

3.  Try to write to User B\'s habits collection

4.  Try to delete User B\'s data

5.  Observe results

Expected Results:

| **Expected Result**                                                     | **Pass/Fail** |
|-------------------------------------------------------------------------|---------------|
| All unauthorized access attempts fail                                   |               |
| Firestore returns \"permission denied\" error (meets S-05 fit criteria) |               |
| User A cannot read User B\'s data                                       |               |
| User A cannot write to User B\'s data                                   |               |
| User A cannot delete User B\'s data                                     |               |
| Firestore rules restrict access (S-05)                                  |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 5.2.3: Data-Sharing Consent Toggle**

Priority: HIGH  
Related Requirements: S-04 (Add a setting toggle for data-sharing
consent)  
Fit Criteria: Toggle exists in the settings screen

Test Steps:

1.  Navigate to app settings screen

2.  Locate data-sharing consent toggle

3.  Verify toggle state (on/off)

4.  Toggle setting and save

5.  Verify preference saved

Expected Results:

| **Expected Result**                                                             | **Pass/Fail** |
|---------------------------------------------------------------------------------|---------------|
| Data-sharing consent toggle exists in settings screen (meets S-04 fit criteria) |               |
| Toggle clearly labeled                                                          |               |
| Toggle state persists after app restart                                         |               |
| User privacy preference saved to Firestore                                      |               |
| Toggle accessible in settings (S-04)                                            |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**5.3 Audit and Activity Tracking (S-03)**

**Test Case 5.3.1: Track Last Login and Recent Activity**

Priority: LOW  
Related Requirements: S-03 (Track last login and recent habit changes
per user)  
Fit Criteria: Visible in Firestore under each user profile

Test Steps:

1.  Log in to app

2.  Check Firestore user document

3.  Verify lastLogin timestamp exists

4.  Create a habit

5.  Check Firestore for habit change record

6.  Complete a habit

7.  Verify activity tracked

Expected Results:

| **Expected Result**                                                              | **Pass/Fail** |
|----------------------------------------------------------------------------------|---------------|
| Last login timestamp visible in Firestore user profile (meets S-03 fit criteria) |               |
| Recent habit changes tracked in Firestore                                        |               |
| Activity data accessible under user profile                                      |               |
| Timestamps accurate                                                              |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**6. Usability Testing**

**6.1 Navigation and Ease of Use Testing (U-01, U-06)**

**Test Case 6.1.1: Simple and Intuitive Navigation**

Priority: HIGH  
Related Requirements: U-01 (The app should have a simple and intuitive
navigation)  
Fit Criteria: Users should be able to perform the main actions without
confusion

Test with 5-10 users:

1.  Ask users to create a habit (without instructions)

2.  Ask users to complete a habit (without instructions)

3.  Ask users to view their progress (without instructions)

4.  Observe and record any confusion or hesitation

Expected Results:

| **Expected Result**                                                | **Pass/Fail** |
|--------------------------------------------------------------------|---------------|
| \>= 90% of users can create habit without help                     |               |
| \>= 90% of users can complete habit without help                   |               |
| \>= 90% of users can find progress screen without help             |               |
| Main actions performed without confusion (meets U-01 fit criteria) |               |
| Navigation is intuitive                                            |               |
| Users express confidence in navigation                             |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**Test Case 6.1.2: Quick Access to Frequently Used Features**

Priority: MEDIUM  
Related Requirements: U-06 (The app should allow quick access to
frequently used features from the home screen)  
Fit Criteria: Users should be able to access habit tracking and progress
with no more than one tap from the dashboard

Test Steps:

1.  Open app to dashboard

2.  Count taps required to complete a habit

3.  Count taps required to view progress

4.  Count taps required to create new habit

Expected Results:

| **Expected Result**                                                             | **Pass/Fail** |
|---------------------------------------------------------------------------------|---------------|
| Habit completion accessible with 1 tap from dashboard (meets U-06 fit criteria) |               |
| Progress view accessible with \<=1 tap from dashboard (U-06)                    |               |
| Create habit button visible on dashboard                                        |               |
| No more than 1 tap for frequent actions                                         |               |
| Quick access improves efficiency (U-06)                                         |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**6.2 Learning and Onboarding Testing (U-02)**

**Test Case 6.2.1: Tutorial on First Launch**

Priority: MEDIUM  
Related Requirements: U-02 (Provide a brief tutorial or guide on the
first launch of the app)  
Fit Criteria: Tutorial or guide should appear on the first login and
should be accessible at any time  
Dependencies: F-01

Test Steps:

1.  Install app fresh (first-time user)

2.  Complete login process

3.  Observe if tutorial appears

4.  Complete tutorial

5.  Navigate to settings

6.  Look for option to replay tutorial

Expected Results:

| **Expected Result**                                             | **Pass/Fail** |
|-----------------------------------------------------------------|---------------|
| Tutorial/guide appears on first login (meets U-02 fit criteria) |               |
| Tutorial explains app\'s purpose and features                   |               |
| Tutorial is brief (2-3 minutes)                                 |               |
| Tutorial can be skipped if user chooses                         |               |
| Tutorial accessible anytime from settings (U-02)                |               |
| Tutorial helps users understand app                             |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**6.3 Personalization Testing (U-03)**

**Test Case 6.3.1: Light and Dark Mode Toggle**

Priority: MEDIUM  
Related Requirements: U-03 (Allow users to choose light or dark mode)  
Fit Criteria: Users should be able to switch themes in the settings menu

Test Steps:

1.  Open app in default light mode

2.  Navigate to settings menu

3.  Locate theme toggle option

4.  Switch to dark mode

5.  Verify UI changes to dark theme

6.  Switch back to light mode

Expected Results:

| **Expected Result**                                            | **Pass/Fail** |
|----------------------------------------------------------------|---------------|
| Theme toggle exists in settings menu (meets U-03 fit criteria) |               |
| Toggle clearly labeled \"Light/Dark Mode\"                     |               |
| Switching to dark mode changes entire UI                       |               |
| All screens support both themes                                |               |
| Theme preference saved                                         |               |
| Theme persists after app restart                               |               |
| Users can switch themes in settings (U-03)                     |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**6.4 Understandability Testing (U-04)**

**Test Case 6.4.1: Clear and Friendly Language**

Priority: MEDIUM  
Related Requirements: U-04 (Use clear and friendly language throughout
the interface)  
Fit Criteria: All error messages should be easy to understand and
written in clear language

Test Steps:

1.  Trigger various error scenarios:

    - Try to create habit with empty name

    - Attempt offline sync

    - Try invalid login

2.  Read each error message

3.  Evaluate clarity and friendliness

Expected Results:

| **Expected Result**                                                     | **Pass/Fail** |
|-------------------------------------------------------------------------|---------------|
| All error messages use clear, simple language (meets U-04 fit criteria) |               |
| Error messages are friendly in tone                                     |               |
| Messages explain what went wrong                                        |               |
| Messages suggest how to fix issue                                       |               |
| No technical language in user-facing text                               |               |
| Language is welcoming and helpful (U-04)                                |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

**6.5 Accessibility Testing (U-05)**

**Test Case 6.5.1: Readable Fonts and Clear Contrast**

Priority: MEDIUM  
Related Requirements: U-05 (The app should use readable fonts, clear
contrast, and support larger system text sizes)  
Fit Criteria: Users should be able to read text clearly, even with
device settings for larger text

Test Steps:

1.  Review app fonts and sizes

2.  Check color contrast ratios

3.  Enable device \"Large Text\" setting (150%, 200%)

4.  Open app and verify text readability

Expected Results:

| **Expected Result**                                                            | **Pass/Fail** |
|--------------------------------------------------------------------------------|---------------|
| Fonts are readable                                                             |               |
| Color contrast meets WCAG standards (\>= 4.5:1)                                |               |
| Text scales correctly with device settings                                     |               |
| Users can read clearly even with larger text enabled (meets U-05 fit criteria) |               |
| No text cut off or overlapping                                                 |               |
| App remains usable with large text                                             |               |

Actual Results:

Status:  
Executed By: \_\_\_\_\_\_\_\_\_\_  
Execution Date: \_\_\_\_\_\_\_\_\_\_  
Notes: \_\_\_\_\_\_\_\_\_\_

## User Acceptance Testing

UAT will involve real users testing the app to ensure that it meets
their needs and expectations. Feedback will be collected to identify
usability issues and potential improvements.

**3.7.1 UAT Overview**

Duration: 1-2 weeks  
Participants: 5-10 real users  
Purpose: Validate app meets user needs in real-world scenarios

**3.7.2 UAT Metrics**

Track the following metrics during UAT period:

**Daily Active Users:**

- Target: \>= 70% of UAT participants use app daily

- Measured through Firebase Analytics

**Habit Completion Rate:**

- Target: \>= 60% of created habits completed regularly

- Measured through Firestore data

**System Usability Scale (SUS):**

- Target: \>= 68 (above average)

- Measured through the post-UAT survey

**3.7.3 UAT Success Criteria**

| **Success criteria**                            | **Pass/Fail** |
|-------------------------------------------------|---------------|
| SUS score ≥68                                   |               |
| \>=70% of participants would continue using app |               |
| No critical (P0) bugs reported                  |               |
| Average feature satisfaction \>= 3.5/5.0        |               |
| \>= 50% daily active usage rate                 |               |

**3.7.4 User Acceptance Testing Survey**

**Survey Administration:**

- Timing: End of Week 2 of UAT (after 1-2 weeks of daily usage)

- Method: Google Forms or printed questionnaire

- Duration: 10-15 minutes to complete

- Anonymous: Participants may remain anonymous if preferred

**GAMIFIED HABIT TRACKER - USER ACCEPTANCE TESTING SURVEY**

Thank you for participating in the User Acceptance Testing for the
Gamified Habit Tracker app called Habit Love! Your honest feedback is
essential to improving the app. This survey should take approximately
10-15 minutes to complete.

**Part A: Background Information**

1.  Participant : \_\_\_\_\_\_\_\_\_\_

2.  How many days did you use the app during the testing period?

    - 1-3 days

    - 4-7 days

    - 8-10 days

    - 11-14 days

3.  How many habits did you create in the app?

    - 1-2 habits

    - 3-5 habits

    - 6-10 habits

    - More than 10 habits

4.  What type of device did you use?

    - iPhone

    - Samsung

    - Google Pixel

    - OnePlus

    - Other Android: \_\_\_\_\_\_\_\_\_\_

5.  Android version:

    - Android 8-9

    - Android 10-11

    - Android 12+

    - Don\'t know

**Part B: System Usability Scale (SUS)**

For each statement below, please rate your level of agreement on a scale
from 1 to 5:

**1 = Strongly Disagree **

** 2 = Disagree **

**3 = Neutral**

**4 = Agree **

**5 = Strongly Agree**

| **\#** | **Statement**                                                             | **1** | **2** | **3** | **4** | **5** |
|--------|---------------------------------------------------------------------------|-------|-------|-------|-------|-------|
| 1      | I think I would like to use this app frequently                           | ☐     | ☐     | ☐     | ☐     | ☐     |
| 2      | I found the app unnecessarily complex                                     | ☐     | ☐     | ☐     | ☐     | ☐     |
| 3      | I thought the app was easy to use                                         | ☐     | ☐     | ☐     | ☐     | ☐     |
| 4      | I think I would need support to be able to use this app                   | ☐     | ☐     | ☐     | ☐     | ☐     |
| 5      | I found the various functions in this app were well integrated            | ☐     | ☐     | ☐     | ☐     | ☐     |
| 6      | I thought there was too much inconsistency in this app                    | ☐     | ☐     | ☐     | ☐     | ☐     |
| 7      | I would imagine that most people would learn to use this app very quickly | ☐     | ☐     | ☐     | ☐     | ☐     |
| 8      | I found the app very cumbersome to use                                    | ☐     | ☐     | ☐     | ☐     | ☐     |
| 9      | I felt very confident using the app                                       | ☐     | ☐     | ☐     | ☐     | ☐     |
| 10     | I needed to learn a lot of things before I could get going with this app  | ☐     | ☐     | ☐     | ☐     | ☐     |

**SUS Scoring Instructions (for researcher):**

- For odd-numbered items (1, 3, 5, 7, 9): Score = rating - 1

- For even-numbered items (2, 4, 6, 8, 10): Score = 5 - rating

- Sum all scores and multiply by 2.5

- Result is SUS score out of 100

- Target: \>= 68 (above average)

**Part C: Feature Satisfaction**

Please rate your satisfaction with each feature on a scale from 1 to 5:

**1 = Very Dissatisfied **

**2 = Dissatisfied **

**3 = Neutral **

**4 = Satisfied **

**5 = Very Satisfied **

**N/A = Did not use**

| **Feature**                                                                     | **1** | **2** | **3** | **4** | **5** | **N/A** |
|---------------------------------------------------------------------------------|-------|-------|-------|-------|-------|---------|
| **Habit Creation** - Creating new habits with name, description, and recurrence | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Habit Management** - Editing and deleting habits                              | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **XP System** - Earning experience points for completing habits                 | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Streak Tracking** - Tracking consecutive days of habit completion             | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Achievement Badges** - Unlocking badges for milestones                        | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Progress Analytics** - Viewing graphs and stats of your progress              | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Notifications/Reminders** - Receiving reminders for habits                    | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Data Synchronization** - Syncing across devices (if tested)                   | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **User Interface** - Overall look and feel of the app                           | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Navigation** - Moving between screens and finding features                    | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |
| **Light/Dark Mode** - Theme options                                             | ☐     | ☐     | ☐     | ☐     | ☐     | ☐       |

**Average Feature Satisfaction Score:** \_\_\_\_\_\_ / 5.0  
**Target:** \>= 4.0/5.0

**Part D: Net Promoter Score (NPS)**

1.  How likely are you to recommend this app to a friend or colleague
    who wants to build better habits?

**0 = Not at all likely **

**10 = Extremely likely**

| **0** | **1** | **2** | **3** | **4** | **5** | **6** | **7** | **8** | **9** | **10** |
|-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|--------|
| ☐     | ☐     | ☐     | ☐     | ☐     | ☐     | ☐     | ☐     | ☐     | ☐     | ☐      |

**Part E: Motivation and Engagement**

1.  Did the gamification features (XP, streaks, badges) motivate you to
    complete your habits more consistently?

    - Yes, significantly

    - Yes, somewhat

    - Not really

    - No, not at all

    - I don\'t know

<!-- -->

1.  Which gamification feature did you find MOST motivating? (Select
    one)

    - XP (Experience Points)

    - Streaks (consecutive days)

    - Achievement Badges

    - Progress Analytics/Graphs

    - None were motivating

    - Other: \_\_\_\_\_\_\_\_\_\_

<!-- -->

1.  Which gamification feature did you find LEAST motivating? (Select
    one)

    - XP (Experience Points)

    - Streaks (consecutive days)

    - Achievement Badges

    - Progress Analytics/Graphs

    - All were motivating

    - Other: \_\_\_\_\_\_\_\_\_\_

<!-- -->

1.  Would you continue using this app after the testing period ends?

    - Yes, definitely

    - Yes, probably

    - Maybe

    - Probably not

    - Definitely not

**Target:** \>= 70% answer \"Yes, definitely\" or \"Yes, probably\"

**Part F: App Performance**

1.  How would you rate the app\'s performance and speed?

    - Excellent - Very fast and responsive

    - Good - Generally fast with minor delays

    - Acceptable - Some noticeable delays

    - Poor - Frequently slow

    - Very Poor - Constantly lagging

<!-- -->

1.  Did you experience any crashes or freezes?

    - No, never

    - Yes, once

    - Yes, 2-3 times

    - Yes, 4-5 times

    - Yes, more than 5 times

<!-- -->

1.  If you experienced crashes, when did they occur? (Check all that
    apply)

    - Did not experience crashes

    - When opening the app

    - When creating a habit

    - When completing a habit

    - When viewing analytics

    - When syncing data

    - Other: \_\_\_\_\_\_\_\_\_\_

**Part G: Open-Ended Feedback**

1.  What did you LIKE MOST about the Gamified Habit Tracker?

<!-- -->

1.  What did you LIKE LEAST about the Gamified Habit Tracker?

<!-- -->

1.  What feature or improvement would make this app MORE useful for you?

<!-- -->

1.  Did you encounter any bugs or issues? If yes, please describe:

<!-- -->

1.  Is there anything else you\'d like to share about your experience
    with the app?

**Part H: Comparison (Optional)**

1.  Have you used other habit tracking apps before?

    - Yes

    - No

<!-- -->

1.  If yes, which apps have you used? (Check all that apply)

    - Habitica

    - Streaks

    - Habit Tracker

    - Loop Habit Tracker

    - Productive

    - Way of Life

    - Other: \_\_\_\_\_\_\_\_\_\_

<!-- -->

1.  How does the "Habit Love" compare to other habit apps you\'ve used?

    - Much better

    - Somewhat better

    - About the same

    - Somewhat worse

    - Much worse

    - Haven\'t used other apps

**Thank you for completing this survey!**

Your feedback is invaluable in making the Gamified Habit Tracker the
best it can be. If you have any additional comments or would like to
discuss your experience further, please contact Marina Skegro.

**Survey Completion Date:** \_\_\_\_\_\_\_\_\_\_

**3.7.5 UAT Survey Analysis Template**

After collecting all surveys, compare results:

**Feature Satisfaction Breakdown:**

| **Feature**        | **Avg Score**    | **Notes** |
|--------------------|------------------|-----------|
| Habit Creation     | \_\_\_\_\_ / 5.0 |           |
| Habit Management   | \_\_\_\_\_ / 5.0 |           |
| XP System          | \_\_\_\_\_ / 5.0 |           |
| Streak Tracking    | \_\_\_\_\_ / 5.0 |           |
| Achievement Badges | \_\_\_\_\_ / 5.0 |           |
| Progress Analytics | \_\_\_\_\_ / 5.0 |           |
| Notifications      | \_\_\_\_\_ / 5.0 |           |
| Data Sync          | \_\_\_\_\_ / 5.0 |           |
| UI Design          | \_\_\_\_\_ / 5.0 |           |
| Navigation         | \_\_\_\_\_ / 5.0 |           |
| Themes             | \_\_\_\_\_ / 5.0 |           |

**Key Findings:**

**- Strengths (What users liked most):**

**- Weaknesses (What users liked least):**

**- Critical Bugs Reported:**

**- Suggested Improvements:**

**3.8 Bug Tracking and Defect Management**

**3.8.1 Bug Severity Levels**

**P0 - Critical:**

- App crashes on launch

- Cannot create or complete habits

- Data loss or corruption  
  Response: Fix within 24 hours  
  Release: CANNOT release with P0 bugs

**P1 - High:**

- XP calculation errors

- Streak tracking broken

- Sync failures  
  Response: Fix within 2-3 days  
  Release: Should NOT release with P1 bugs

**P2 - Medium:**

- UI glitches

- Minor calculation errors  
  Response: Fix before release if time allows  
  Release: Can release with documented P2 bugs

**P3 - Low:**

- Cosmetic issues

- Enhancement requests  
  Response: Fix in future updates  
  Release: Can release with P3 bugs

**Release Criteria - ALL must be met:**

| **Release Criteria**                                                                                                                    | **Pass/Fail** |
|-----------------------------------------------------------------------------------------------------------------------------------------|---------------|
| All HIGH priority requirements working (F-01, F-02, F-03, F-07, P-01, P-02, P-03, P-07, P-08, S-01, S-02, S-04, S-05, U-01, M-01, M-02) |               |
| Zero P0 bugs                                                                                                                            |               |
| Zero P1 bugs                                                                                                                            |               |
| Unit test coverage \>= 70%                                                                                                              |               |
| Dashboard loads within 3-5 seconds (P-01)                                                                                               |               |
| App supports 50 habits (P-06)                                                                                                           |               |
| Data syncs across devices (F-07)                                                                                                        |               |
| XP and streak calculations accurate (P-07)                                                                                              |               |
| No crashes on force-close (P-08)                                                                                                        |               |
| Only authenticated users access data (S-01)                                                                                             |               |
| SUS score \>= 68                                                                                                                        |               |
| Professor Henderson\'s approval obtained                                                                                                |               |

## 3.8 Regression Testing  {#regression-testing .unnumbered}

Regression testing will be performed after each update to ensure that
new changes do not negatively affect existing functionalities.

# Execution Strategy

##  Entry Criteria {#entry-criteria}

Testing will begin once the app build is complete, Firebase integration
is configured, and core features are stable and ready for validation.

<table>
<colgroup>
<col style="width: 60%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Entry Criteria</strong></th>
<th><strong>Test Team</strong></th>
<th><strong>Technical Team</strong></th>
<th><strong>Notes</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><blockquote>
<p><em>Test environment(s) is available</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>Test data is available</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><em>Code has been merged successfully</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>Development has completed unit testing</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><em>Test scripts are completed, reviewed and approved</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

##  Exit criteria {#exit-criteria}

Testing will conclude when 100% of critical test cases are executed,
with a minimum of 90% passing rate. All high-priority defects must be
resolved or documented with mitigation plans.

<table>
<colgroup>
<col style="width: 60%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 15%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Exit Criteria</strong></th>
<th><strong>Test Team</strong></th>
<th><strong>Technical Team</strong></th>
<th><strong>Notes</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><blockquote>
<p><em>100% Test Scripts executed</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>90% pass rate of Test Scripts</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><em>No open Critical and High severity defects</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>All remaining defects are either cancelled or documented as
Change Requests for a future release</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><em>All expected and actual results are captured and documented with
the test script</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>All test metrics collected based on reports from daily and Weekly
Status reports</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td><blockquote>
<p><em>All defects logged in Defect Tracker/Spreadsheet</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td><blockquote>
<p><em>Test environment cleanup completed and a new back up of the
environment</em></p>
</blockquote></td>
<td></td>
<td></td>
<td></td>
</tr>
</tbody>
</table>

##  Validation and Defect Management {#validation-and-defect-management}

All test cases and scenarios will be validated against functional and
non-functional requirements. Defects will be logged, tracked, and
resolved through GitHub Issues. Severity levels will be categorized as
Critical, High, Medium, or Low.

<table>
<colgroup>
<col style="width: 37%" />
<col style="width: 62%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Severity</strong></th>
<th><strong>Impact</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><em>1 (Critical)</em></td>
<td><ul>
<li><p>Functionality is blocked; application is unusable.</p></li>
</ul></td>
</tr>
<tr class="even">
<td><em>2 (High)</em></td>
<td><ul>
<li><p>Functionality not usable; no workaround available.</p></li>
</ul></td>
</tr>
<tr class="odd">
<td><em>3 (Medium)</em></td>
<td><ul>
<li><p>Issues present but workaround exists.</p></li>
</ul></td>
</tr>
<tr class="even">
<td><em>4 (Low)</em></td>
<td><ul>
<li><p>Minor or cosmetic errors with minimal impact.</p></li>
</ul></td>
</tr>
</tbody>
</table>

# Environment Requirements

##  Test Environments {#test-environments}

[]{#_Toc515524414 .anchor}Testing will occur in the Flutter development
environment using VS Code. Firebase's test environment will handle
backend validation, and physical iOS devices will be used for real-world
testing.

# Significantly Impacted Division/College/Department

Department: Computer Science  
Faculty: Charleston Southern University  
Advising Professor: Professor Julie Henderson

# Dependencies

Dependencies include Flutter SDK, Firebase Authentication, Firestore,
and notification libraries. Testing also depends on the availability of
stable internet connectivity and valid test devices
