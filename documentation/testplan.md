# Testing Documentation
## Gamified Habit Tracker — Habit Love

---

## 8. Functional Test Cases

### 8.1 Habit Creation and Customization Testing (F-01)

This section provides detailed test cases for habit creation and customization, which form the core functionality of the application.

#### Test Case 8.1.1: Create Habit with Name, Description, and Recurrence Settings

- **Priority:** HIGH
- **Related Requirements:** F-01 (Users can create and customize habits with names, descriptions, and recurrence settings)
- **Fit Criteria:** The user should be able to create at least five habits during a session

**Preconditions:**
- User is logged in successfully via Google or Email authentication (S-02)
- Dashboard screen is displayed
- Firebase Firestore connection is active

**Test Steps:**
1. Locate and tap the '+' floating action button on the dashboard
2. Verify habit creation screen opens
3. Enter habit name: 'Morning Exercise'
4. Enter description: 'Run for 30 minutes every morning'
5. Select recurrence setting: 'Daily'
6. Tap 'Save' button
7. Verify habit appears in dashboard

| Expected Result | Pass/Fail |
|---|---|
| Habit creation screen opens immediately upon tapping '+' | ✅ PASS |
| All input fields (name, description, recurrence) accept data correctly | ✅ PASS |
| 'Save' button becomes enabled when name field is filled | ✅ PASS |
| Habit saves to Firestore successfully | ✅ PASS |
| User returns to dashboard automatically | ✅ PASS |
| New habit 'Morning Exercise' appears in habit list | ✅ PASS |
| Habit displays with correct recurrence setting (Daily) | ✅ PASS |
| Success message displays: 'Habit created successfully!' | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 10

---

#### Test Case 8.1.2: Create Multiple Habits in One Session

- **Priority:** HIGH
- **Related Requirements:** F-01
- **Fit Criteria:** The user should be able to create at least five habits during a session

**Test Steps:**
1. Create habit #1: 'Drink Water' - Daily recurrence
2. Create habit #2: 'Read Books' - Daily recurrence
3. Create habit #3: 'Yoga Practice' - Weekly recurrence (Mondays, Wednesdays)
4. Create habit #4: 'Meditation' - Daily recurrence
5. Create habit #5: 'Meal Prep' - Weekly recurrence (Sundays)
6. Verify all 5 habits appear in dashboard

| Expected Result | Pass/Fail |
|---|---|
| All 5 habits created successfully without errors | ✅ PASS |
| Each habit saves to Firestore with correct data | ✅ PASS |
| Dashboard displays all 5 habits | ✅ PASS |
| Daily recurrence habits show "Every day" indicator | ✅ PASS |
| Weekly recurrence habits show specific days | ✅ PASS |
| No performance degradation when creating multiple habits | ✅ PASS |
| User able to create 5+ habits in single session (meets F-01 fit criteria) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 10

---

#### Test Case 8.1.3: Customize Habit with All Available Options

- **Priority:** HIGH
- **Related Requirements:** F-01

**Test Steps:**
1. Create new habit with the following customizations:
   - Name: 'Evening Yoga Session'
   - Description: '30 minutes of relaxing yoga and stretching before bed'
   - Time Range: 'Anytime, Morning, Afternoon, Evening'
2. Save habit
3. Verify all customizations are preserved

| Expected Result | Pass/Fail |
|---|---|
| All three elements (name, description, time range) save correctly | ✅ PASS |
| Habit displays with full description when viewed | ✅ PASS |
| Custom range shows only selected time range | ✅ PASS |
| Habit appears on dashboard only on specified time range | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 10

---

#### Test Case 8.1.4: Edit Existing Habit Customizations

- **Priority:** HIGH
- **Related Requirements:** F-01
- **Dependencies:** Habit must exist first

**Test Steps:**
1. Select existing habit 'Morning Exercise'
2. Edit name to 'Morning Jog'
3. Edit description to 'Jog for 30 minutes around the park'
4. Save changes

| Expected Result | Pass/Fail |
|---|---|
| Edit screen opens with current values pre-filled | ✅ PASS |
| Changes save successfully to Firestore | ✅ PASS |
| Habit updates in list immediately | ✅ PASS |
| New name 'Morning Jog' displays correctly | ✅ PASS |
| Historical data (streaks, XP) preserved (P-07) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 10

---

#### Test Case 8.1.5: Delete Habit

- **Priority:** HIGH
- **Related Requirements:** F-01

**Test Steps:**
1. Long-press on habit 'Yoga Session'
2. Select 'Delete' option
3. Confirm deletion in dialog

| Expected Result | Pass/Fail |
|---|---|
| Confirmation dialog appears: "Are you sure you want to delete this habit?" | ✅ PASS |
| On 'Delete': Habit removed from dashboard | ✅ PASS |
| On 'Delete': Habit removed from Firestore | ✅ PASS |
| On 'Cancel': Nothing changes, habit remains | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 10

---

### 8.2 Experience Points (XP) System Testing (F-02)

The XP system motivates users through gamification by awarding points for habit completion.

#### Test Case 8.2.1: XP Award Immediately After Habit Completion

- **Priority:** CRITICAL
- **Related Requirements:** F-02 (Users earn experience points (XP) for completing habits)
- **Fit Criteria:** XP should update immediately after habit completion
- **Dependencies:** F-01 (Requires existing habit)

**Preconditions:**
- User has habit 'Jog' created
- User's current total XP = 0
- Habit has not been completed today

**Test Steps:**
1. Navigate to dashboard
2. Note current total XP
3. Tap checkbox to mark 'Jog' as complete
4. Observe XP update timing
5. Check total XP value

| Expected Result | Pass/Fail |
|---|---|
| Checkbox shows checked state immediately | ✅ PASS |
| XP updates IMMEDIATELY after completion (meets F-02 fit criteria) | ✅ PASS |
| XP gain animation displays (implemented per LF-02) | ✅ PASS |
| User's total XP increases by base amount (e.g., 10 XP) | ✅ PASS |
| XP displays in profile/dashboard | ✅ PASS |
| XP saved to Firestore user document | ✅ PASS |

> **Timing Verification:** XP must update immediately (< 1 second) to meet F-02 fit criteria. Visual feedback should be instant.

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

#### Test Case 8.2.2: XP Calculation Accuracy

- **Priority:** HIGH
- **Related Requirements:** F-02, P-07
- **Fit Criteria:** Test data consistency by completing and undoing habits multiple times

**Test Steps:**
1. Note starting XP: 0
2. Complete 'Morning Jog' — Expected: +10 XP (Total: 10)
3. Complete 'Drink Water' — Expected: +10 XP (Total: 20)
4. Complete 'Meditation' — Expected: +10 XP (Total: 30)
5. Uncheck 'Meditation' — Expected: -10 XP (Total: 20)
6. Re-check 'Meditation' — Expected: +10 XP (Total: 30)
7. Verify final total

| Expected Result | Pass/Fail |
|---|---|
| Each completion adds correct XP amount | ✅ PASS |
| Unchecking removes XP correctly | ✅ PASS |
| Re-checking adds XP back | ✅ PASS |
| Final XP calculation is accurate: 30 XP | ✅ PASS |
| XP calculations remain consistent after multiple changes (meets P-07) | ✅ PASS |
| No rounding errors or calculation bugs | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

#### Test Case 8.2.3: XP with Streak Bonus

- **Priority:** HIGH
- **Related Requirements:** F-02, F-03
- **Dependencies:** F-03 (Streak tracking)

**Preconditions:**
- Habit 'Morning Jog' has 7-day active streak

**Test Steps:**
1. Complete habit with 7-day streak
2. Observe XP awarded
3. Verify bonus calculation

| Expected Result | Pass/Fail |
|---|---|
| Base XP awarded (10 points) | ✅ PASS |
| Streak bonus applied for 7+ day streak | ✅ PASS |
| Total XP reflects both base + bonus | ✅ PASS |
| Calculation accurate (meets P-07) | ✅ PASS |
| XP updates immediately (meets F-02) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

### 8.3 Streak Tracking System Testing (F-03)

Streak tracking encourages consistent habit formation by displaying consecutive completion days.

#### Test Case 8.3.1: Display Streak Count for Each Habit

- **Priority:** HIGH
- **Related Requirements:** F-03
- **Fit Criteria:** The app should display streak count for each habit
- **Dependencies:** F-01

**Preconditions:**
- User has habit 'Morning Jog' with some completion history

**Test Steps:**
1. View habit list on dashboard
2. Locate 'Morning Jog' habit
3. Check for streak counter display
4. Note streak number shown

| Expected Result | Pass/Fail |
|---|---|
| Streak count visible on habit card (meets F-03 fit criteria) | ✅ PASS |
| Streak displays as number (e.g., "5-day streak") | ✅ PASS |
| Streak is correctly displayed | ✅ PASS |
| Streak count is accurate based on completion history | ✅ PASS |
| Each habit shows its own individual streak | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

#### Test Case 8.3.2: Streak Increments on Consecutive Completion

- **Priority:** HIGH
- **Related Requirements:** F-03, P-07

**Preconditions:**
- Habit 'Morning Jog' completed yesterday
- Current streak = 5 days

**Test Steps:**
1. Note current streak: 5 days
2. Complete 'Morning Jog' today
3. Check updated streak count

| Expected Result | Pass/Fail |
|---|---|
| Streak increments from 5 to 6 | ✅ PASS |
| Streak update is immediate | ✅ PASS |
| Streak calculation is accurate (consecutive days counted correctly per P-07) | ✅ PASS |
| Streak displayed correctly for this habit (F-03) | ✅ PASS |
| Last completion date updates to today | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

#### Test Case 8.3.3: Streak Resets After Missed Day

- **Priority:** HIGH
- **Related Requirements:** F-03, P-07

**Preconditions:**
- Habit 'Meditation' last completed 2 days ago
- Current streak = 10 days

**Test Steps:**
1. Note current streak: 10 days
2. Complete 'Meditation' today (missed yesterday)
3. Observe streak counter

| Expected Result | Pass/Fail |
|---|---|
| Streak resets to 1 day (fresh start) | ✅ PASS |
| Previous streak of 10 days stored as "longest streak" | ✅ PASS |
| Reset calculation is accurate (P-07) | ✅ PASS |
| New streak count displays correctly (F-03) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 25

---

#### Test Case 8.3.4: Streak Accuracy with Multiple Habits

- **Priority:** HIGH
- **Related Requirements:** F-03, P-07
- **Fit Criteria:** Test data consistency by completing and undoing habits multiple times

**Test Steps:**
1. Complete 'Morning Jog' (Streak: 1)
2. Complete 'Drink Water' (Streak: 1)
3. Complete 'Meditation' (Streak: 1)
4. Next day: Complete all three habits again
5. Uncheck 'Meditation', then re-check it
6. Verify all streak counts

| Expected Result | Pass/Fail |
|---|---|
| Each habit maintains independent streak counter | ✅ PASS |
| All three habits show Streak: 2 after day 2 | ✅ PASS |
| Unchecking and re-checking doesn't affect streak | ✅ PASS |
| Streak calculations accurate for all habits (P-07) | ✅ PASS |
| All streaks display correctly (F-03) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 15

---

### 8.4 Achievement Badge System Testing (F-04)

Achievement badges encourage long-term habit tracking by recognizing milestones.

#### Test Case 8.4.1: Achievement Appears in Profile When Unlocked

- **Priority:** MEDIUM
- **Related Requirements:** F-04
- **Fit Criteria:** Achievements should appear in the user profile when unlocked
- **Dependencies:** F-03

**Preconditions:**
- User has no achievements unlocked
- User profile screen accessible

**Test Steps:**
1. Complete habit for 7 consecutive days to reach milestone
2. Check if achievement unlocks
3. Navigate to user profile
4. Verify achievement display

| Expected Result | Pass/Fail |
|---|---|
| Achievement unlocks upon reaching 7-day streak milestone | ✅ PASS |
| Achievement appears in user profile (meets F-04 fit criteria) | ✅ PASS |
| Achievement displays with badge icon | ✅ PASS |
| Achievement shows unlock date | ✅ PASS |
| Achievement saved to Firestore | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 19

---

#### Test Case 8.4.2: Multiple Achievement Milestones

- **Priority:** MEDIUM
- **Related Requirements:** F-04

**Test Steps:**
1. Unlock "Week Warrior" achievement (7-day streak)
2. Navigate to profile, verify it appears
3. Continue to unlock "Month Master" achievement (30-day streak)
4. Navigate to profile, verify both appear
5. Unlock "XP Champion" achievement (1000 total XP)
6. Verify all three achievements in profile

| Expected Result | Pass/Fail |
|---|---|
| All unlocked achievements appear in profile | ✅ PASS |
| Achievements listed chronologically or by category | ✅ PASS |
| Each achievement shows unlock date | ✅ PASS |
| Profile displays total achievement count | ✅ PASS |
| Locked achievements shown in grayed-out state | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 19

---

#### Test Case 8.4.3: Achievement Unlock Does Not Affect Other Data

- **Priority:** MEDIUM
- **Related Requirements:** F-04, P-07

**Test Steps:**
1. Track current XP and streak counts
2. Unlock achievement
3. Verify XP and streaks unchanged

| Expected Result | Pass/Fail |
|---|---|
| Achievement unlock process doesn't modify XP totals | ✅ PASS |
| Achievement unlock doesn't affect streak counts | ✅ PASS |
| All data remains accurate (P-07) | ✅ PASS |
| Only achievement status changes | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 20

---

### 8.5 Progress Analytics Testing (F-05)

Analytics visualize progress to motivate habit consistency through graphs and trends.

#### Test Case 8.5.1: Display Simple Progress Graphs

- **Priority:** MEDIUM
- **Related Requirements:** F-05
- **Fit Criteria:** Show simple progress graphs, such as weekly or daily trends
- **Dependencies:** F-01

**Preconditions:**
- User has completed habits over multiple days
- Analytics screen accessible from dashboard

**Test Steps:**
1. Navigate to analytics/progress screen
2. Verify graph displays
3. Check for weekly trend graph
4. Check for daily trend graph

| Expected Result | Pass/Fail |
|---|---|
| Analytics screen displays progress graphs (meets F-05 fit criteria) | ✅ PASS |
| Weekly trends graph visible showing habit completions | ✅ PASS |
| Daily trends visible | ✅ PASS |
| XP progress over time displayed (weekly/monthly) | ✅ PASS |
| Streak history graph shown | ✅ PASS |
| Graphs are simple and easy to understand | ✅ PASS |
| Graph data reflects actual completion history | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 1

---

#### Test Case 8.5.2: Analytics Accuracy

- **Priority:** MEDIUM
- **Related Requirements:** F-05, P-07

**Test Steps:**
1. Complete 3 habits on Day 1
2. Complete 5 habits on Day 2
3. Complete 2 habits on Day 3
4. View analytics screen
5. Verify graph data matches actual completions

| Expected Result | Pass/Fail |
|---|---|
| Day 1 shows 3 completions in graph | ✅ PASS |
| Day 2 shows 5 completions in graph | ✅ PASS |
| Day 3 shows 2 completions in graph | ✅ PASS |
| Data visualization is accurate (P-07) | ✅ PASS |
| Weekly totals calculate correctly | ✅ PASS |
| Monthly totals accurate | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 12

---

#### Test Case 8.5.3: Empty State Analytics

- **Priority:** LOW
- **Related Requirements:** F-05

**Preconditions:**
- New user with no habit completion history

**Test Steps:**
1. Navigate to analytics screen
2. Observe display

| Expected Result | Pass/Fail |
|---|---|
| Analytics screen doesn't crash with no data | ✅ PASS |
| Empty state message displays | ✅ PASS |
| Empty graphs shown or placeholder message | ✅ PASS |
| No errors or broken visualizations | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 13

---

### 8.6 Notification and Reminder System Testing (F-06)

> **Note:** The following features were planned but not implemented in the current version due to time constraints and will be considered for future development.

#### Test Case 8.6.1: Notification Triggers at Set Time

- **Priority:** LOW (Future Enhancement)
- **Related Requirements:** F-06
- **Fit Criteria:** The notification should trigger at the set time, if they are enabled

| Expected Result | Pass/Fail |
|---|---|
| Notification triggers at 7:00 AM (meets F-06 fit criteria) | 🔄 Future Work |
| Notification appears within ±1 minute of set time | 🔄 Future Work |
| Notification only appears if enabled | 🔄 Future Work |
| Notification includes habit name | 🔄 Future Work |
| Tapping notification opens app to habit | 🔄 Future Work |

---

#### Test Case 8.6.2: Enable/Disable Notifications

- **Priority:** LOW
- **Related Requirements:** F-06

| Expected Result | Pass/Fail |
|---|---|
| When enabled, notifications trigger at set time | 🔄 Future Work |
| When disabled, notifications do not trigger | 🔄 Future Work |
| Toggle setting works correctly | 🔄 Future Work |
| Preference saved to Firestore | 🔄 Future Work |

---

#### Test Case 8.6.3: Offline Reminder Support

- **Priority:** LOW
- **Related Requirements:** F-06

| Expected Result | Pass/Fail |
|---|---|
| Local notification triggers even offline | 🔄 Future Work |
| Uses Flutter Local Notifications package | 🔄 Future Work |
| Notification content accurate | 🔄 Future Work |
| Tapping opens app when back online | 🔄 Future Work |

---

### 8.7 Data Synchronization Testing (F-07)

Cloud-based storage ensures data accessibility across multiple devices.

#### Test Case 8.7.1: Sync Data Across Multiple Devices

- **Priority:** HIGH
- **Related Requirements:** F-07
- **Fit Criteria:** Data should sync on a different logged-in device

**Preconditions:**
- Same user account logged in on Device A and Device B
- Both devices have internet connection

**Test Steps:**
1. On Device A: Create habit 'Test Sync Habit'
2. On Device A: Complete the habit
3. On Device B: Open app or refresh
4. Verify habit appears on Device B

| Expected Result | Pass/Fail |
|---|---|
| Habit created on Device A appears on Device B (meets F-07 fit criteria) | ✅ PASS |
| Completion status syncs to Device B | ✅ PASS |
| XP total syncs correctly | ✅ PASS |
| Streak count matches across devices | ✅ PASS |
| All habit data consistent between devices | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 1

---

#### Test Case 8.7.2: Automatic Sync When Network Restored

- **Priority:** HIGH
- **Related Requirements:** F-07, P-03
- **Fit Criteria:** Sync data once the network is available after the connection is restored

**Test Steps:**
1. Disable internet connection on device
2. Complete 3 habits while offline
3. Create 1 new habit while offline
4. Re-enable internet connection
5. Wait for sync to occur
6. Check second device for updates

| Expected Result | Pass/Fail |
|---|---|
| When network restored, sync occurs automatically (meets P-03 fit criteria) | ✅ PASS |
| Offline changes queue locally | ✅ PASS |
| All 3 completed habits sync to cloud | ✅ PASS |
| New habit appears in Firestore | ✅ PASS |
| Second device receives updates | ✅ PASS |
| No data loss during offline period | ✅ PASS |
| Sync happens once network available (P-03) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 1

---

#### Test Case 8.7.3: Sync Data Integrity

- **Priority:** HIGH
- **Related Requirements:** F-07, P-07

**Test Steps:**
1. On Device A: Complete 'Morning Jog' (XP: +10)
2. On Device A: Complete 'Drink Water' (XP: +10)
3. Total XP on Device A: 20
4. On Device B: Login and sync
5. Verify XP total and habit completions

| Expected Result | Pass/Fail |
|---|---|
| Device B shows same XP total (20) as Device A | ✅ PASS |
| Both habits show as completed on Device B | ✅ PASS |
| Streak counts identical on both devices | ✅ PASS |
| Achievement unlocks synced | ✅ PASS |
| Data integrity maintained (P-07) | ✅ PASS |
| No data corruption during sync | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 3

---

## 9. Performance Testing

### 9.1 App Launch and Load Time Testing (P-01)

#### Test Case 9.1.1: Dashboard Loads Within 3-5 Seconds

- **Priority:** HIGH
- **Related Requirements:** P-01
- **Fit Criteria:** Measure load time with Firebase profiling tools

**Test Environment:**
- Mid-range iOS/Android device
- App not in memory (force-closed)
- Internet connection available

**Test Steps:**
1. Force-close app completely
2. Start Firebase Performance Monitoring
3. Tap app icon
4. Measure time until dashboard fully loaded and interactive
5. Record load time
6. Repeat test 10 times
7. Calculate average load time

| Expected Result | Pass/Fail |
|---|---|
| Dashboard loads within 3-5 seconds (meets P-01 fit criteria) | ✅ PASS |
| Firebase profiling tools confirm measurement | ✅ PASS |
| Average load time across 10 tests ≤ 5 seconds | ✅ PASS |
| 90th percentile load time ≤ 5 seconds | ✅ PASS |
| No crashes during launch | ✅ PASS |

**Measurement Method:**
- Use Firebase Performance Monitoring as specified in P-01
- Record cold start time
- Document average, median, and 90th percentile

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 3

---

### 9.2 Scalability and Data Handling (P-02, P-06)

#### Test Case 9.2.1: Handle Increasing Data Without Performance Degradation

- **Priority:** HIGH
- **Related Requirements:** P-02
- **Fit Criteria:** Performance tests should show that data processing, syncing, and UI responsiveness remain stable

**Test Steps:**
1. Create 10 habits, complete them for 1 week
2. Test dashboard load time and responsiveness
3. Increase to 25 habits, complete for 2 weeks
4. Re-test performance metrics
5. Increase to 50 habits, complete for 4 weeks
6. Final performance test

| Expected Result | Pass/Fail |
|---|---|
| Data processing remains stable with increasing data (meets P-02) | ✅ PASS |
| Syncing performance stays consistent | ✅ PASS |
| UI remains responsive at all data volumes | ✅ PASS |
| Dashboard scrolling smooth with 50 habits | ✅ PASS |
| No lagging or glitching | ✅ PASS |
| Performance tests show stability (P-02 fit criteria) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 5

---

#### Test Case 9.2.2: Support 50 Habits Without Slowdown

- **Priority:** MEDIUM
- **Related Requirements:** P-06
- **Fit Criteria:** Test response time while interacting with 50 habits

**Test Steps:**
1. Create test account with exactly 50 habits
2. Load dashboard and measure time
3. Scroll through all 50 habits
4. Select and complete 5 habits
5. Measure response times for each action

| Expected Result | Pass/Fail |
|---|---|
| App supports 50 habits successfully (meets P-06) | ✅ PASS |
| Dashboard loads all 50 habits without slowdown | ✅ PASS |
| Scrolling remains smooth | ✅ PASS |
| Habit completion response time acceptable | ✅ PASS |
| No performance degradation with 50 habits (P-06 fit criteria) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 5

---

### 9.3 Data Robustness Testing (P-03, P-08)

#### Test Case 9.3.1: No Crash or Data Corruption When Suddenly Closed

- **Priority:** HIGH
- **Related Requirements:** P-08
- **Fit Criteria:** Simulate force-closing the app and check for saved state and no corrupted data

**Test Steps:**
1. Create new habit 'Test Habit'
2. Complete the habit (gain XP)
3. Immediately force-close app (swipe away from recent apps)
4. Reopen app
5. Check habit status and XP

| Expected Result | Pass/Fail |
|---|---|
| App does not crash when force-closed (meets P-08) | ✅ PASS |
| Habit 'Test Habit' still exists after reopen | ✅ PASS |
| Completion status preserved | ✅ PASS |
| XP total accurate and not corrupted | ✅ PASS |
| Saved state correct (meets P-08 fit criteria) | ✅ PASS |
| No data corruption detected | ✅ PASS |
| User data remains safe (P-08) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 5

---

### 9.4 Accuracy and Precision Testing (P-07)

#### Test Case 9.4.1: XP and Streak Calculations Are Accurate

- **Priority:** HIGH
- **Related Requirements:** P-07
- **Fit Criteria:** Test data consistency by completing and undoing habits multiple times

**Test Steps:**
1. Start with 0 XP, 0 streaks
2. Complete habit Day 1 — Record XP and streak
3. Complete habit Day 2 — Record XP and streak
4. Skip Day 3 — Check if streak resets
5. Complete habit Day 4 — Verify calculations
6. Uncheck habit Day 4 — Verify XP deduction
7. Re-check habit Day 4 — Verify XP re-addition
8. Complete multiple times same day — Verify no duplicate XP

| Expected Result | Pass/Fail |
|---|---|
| All XP calculations mathematically accurate | ✅ PASS |
| Streak increments correctly on consecutive days | ✅ PASS |
| Streak resets correctly after missed day | ✅ PASS |
| Unchecking removes XP correctly | ✅ PASS |
| Re-checking adds XP back correctly | ✅ PASS |
| No duplicate XP on same-day multiple completions | ✅ PASS |
| Data remains consistent through multiple changes (meets P-07 fit criteria) | ✅ PASS |
| Accuracy maintained (P-07) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 10

---

### 9.5 Reliability and Availability Testing (P-04)

#### Test Case 9.5.1: App Usable 95% of Time During Testing

- **Priority:** MEDIUM
- **Related Requirements:** P-04
- **Fit Criteria:** Test uptime during repeated simulated sessions and check for crashes or loading issues

**Test Protocol:**
- Duration: 1 week of testing
- Sessions: 10 usage sessions per day (70 total sessions)
- Each session: 5-10 minutes of normal usage

**Test Steps:**
1. Launch app 10 times per day for 7 days
2. Use app normally for 5-10 minutes each session
3. Track successful sessions vs failed sessions
4. Record any crashes or loading issues
5. Calculate availability percentage

| Expected Result | Pass/Fail |
|---|---|
| App successfully launches and is usable >= 95% of test sessions | ✅ PASS |
| Successful sessions >= 67 out of 70 (95%) | ✅ PASS |
| Crashes occur in < 5% of sessions | ✅ PASS |
| Loading issues minimal | ✅ PASS |
| Meets P-04 fit criteria (95% uptime) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 9

---

## 10. Security Testing

### 10.1 Authentication and Access Testing (S-02)

#### Test Case 10.1.1: Google Login Authentication

- **Priority:** HIGH
- **Related Requirements:** S-02
- **Fit Criteria:** Users can log in using Google

**Preconditions:**
- Firebase Authentication configured
- Google Sign-In enabled in Firebase console

**Test Steps:**
1. Open app (not logged in)
2. Tap 'Sign in with Google' button
3. Select Google account
4. Allow permissions
5. Verify successful login

| Expected Result | Pass/Fail |
|---|---|
| Google Sign-In button displays on login screen | ✅ PASS |
| Tapping button opens Google account selector | ✅ PASS |
| User can select account and allow permissions | ✅ PASS |
| Login succeeds and user directed to dashboard (meets S-02 fit criteria) | ✅ PASS |
| Firebase Authentication creates user session | ✅ PASS |
| User data accessible after login | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 9

---

#### Test Case 10.1.2: Email/Password Login

- **Priority:** MEDIUM
- **Related Requirements:** S-02

**Test Steps:**
1. Tap 'Sign up with Email' option
2. Enter email and password
3. Create account
4. Logout
5. Login again with same credentials

| Expected Result | Pass/Fail |
|---|---|
| Email/password registration works | ✅ PASS |
| Login with email/password successful | ✅ PASS |
| Authentication uses Firebase | ✅ PASS |
| Optional implementation as per S-02 | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 3

---

### 10.2 Data Security and Privacy Testing (S-01, S-04, S-05)

#### Test Case 10.2.1: Only Authenticated Users Can Access Data

- **Priority:** HIGH
- **Related Requirements:** S-01
- **Fit Criteria:** Only authenticated users can access their data

**Test Steps:**
1. Attempt to access Firestore data without logging in
2. Verify access denied
3. Log in as User A
4. Access User A's habit data
5. Attempt to access User B's habit data while logged in as User A

| Expected Result | Pass/Fail |
|---|---|
| Unauthenticated access to Firestore is denied | ✅ PASS |
| User A can access only their own data (meets S-01 fit criteria) | ✅ PASS |
| User A cannot access User B's data | ✅ PASS |
| Firestore Security Rules enforce authentication | ✅ PASS |
| Only authenticated users access their data (S-01) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 7

---

#### Test Case 10.2.2: Firestore Rules Restrict Unauthorized Access

- **Priority:** HIGH
- **Related Requirements:** S-05
- **Fit Criteria:** Unauthorized access attempts return permission denied

**Test Steps:**
1. Log in as User A
2. Try to read User B's habits collection
3. Try to write to User B's habits collection
4. Try to delete User B's data
5. Observe results

| Expected Result | Pass/Fail |
|---|---|
| All unauthorized access attempts fail | ✅ PASS |
| Firestore returns "permission denied" error (meets S-05 fit criteria) | ✅ PASS |
| User A cannot read User B's data | ✅ PASS |
| User A cannot write to User B's data | ✅ PASS |
| User A cannot delete User B's data | ✅ PASS |
| Firestore rules restrict access (S-05) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 11

---

#### Test Case 10.2.3: Data-Sharing Consent Toggle

- **Priority:** HIGH
- **Related Requirements:** S-04
- **Fit Criteria:** Toggle exists in the settings screen

**Test Steps:**
1. Navigate to app settings screen
2. Locate data-sharing consent toggle
3. Verify toggle state (on/off)
4. Toggle setting and save
5. Verify preference saved

| Expected Result | Pass/Fail |
|---|---|
| Data-sharing consent toggle exists in settings screen (meets S-04 fit criteria) | ✅ PASS |
| Toggle clearly labeled | ✅ PASS |
| Toggle state persists after app restart | ✅ PASS |
| User privacy preference saved to Firestore | ✅ PASS |
| Toggle accessible in settings (S-04) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 12

---

### 10.3 Audit and Activity Tracking (S-03)

#### Test Case 10.3.1: Track Last Login and Recent Activity

- **Priority:** LOW
- **Related Requirements:** S-03
- **Fit Criteria:** Visible in Firestore under each user profile

**Test Steps:**
1. Log in to app
2. Check Firestore user document
3. Verify lastLogin timestamp exists
4. Create a habit
5. Check Firestore for habit change record
6. Complete a habit
7. Verify activity tracked

| Expected Result | Pass/Fail |
|---|---|
| Last login timestamp visible in Firestore user profile (meets S-03 fit criteria) | ✅ PASS |
| Recent habit changes tracked in Firestore | ✅ PASS |
| Activity data accessible under user profile | ✅ PASS |
| Timestamps accurate | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 3

---

## 11. Usability Testing

### 11.1 Navigation and Ease of Use Testing (U-01, U-06)

#### Test Case 11.1.1: Simple and Intuitive Navigation

- **Priority:** HIGH
- **Related Requirements:** U-01
- **Fit Criteria:** Users should be able to perform the main actions without confusion

**Test with 5-10 users:**
1. Ask users to create a habit (without instructions)
2. Ask users to complete a habit (without instructions)
3. Ask users to view their progress (without instructions)
4. Observe and record any confusion or hesitation

| Expected Result | Pass/Fail |
|---|---|
| >= 90% of users can create habit without help | ✅ PASS |
| >= 90% of users can complete habit without help | ✅ PASS |
| >= 90% of users can find progress screen without help | ✅ PASS |
| Main actions performed without confusion (meets U-01 fit criteria) | ✅ PASS |
| Navigation is intuitive | ✅ PASS |
| Users express confidence in navigation | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 16

---

#### Test Case 11.1.2: Quick Access to Frequently Used Features

- **Priority:** MEDIUM
- **Related Requirements:** U-06
- **Fit Criteria:** Users should be able to access habit tracking and progress with no more than one tap from the dashboard

**Test Steps:**
1. Open app to dashboard
2. Count taps required to complete a habit
3. Count taps required to view progress
4. Count taps required to create new habit

| Expected Result | Pass/Fail |
|---|---|
| Habit completion accessible with 1 tap from dashboard (meets U-06 fit criteria) | ✅ PASS |
| Progress view accessible with <=1 tap from dashboard (U-06) | ✅ PASS |
| Create habit button visible on dashboard | ✅ PASS |
| No more than 1 tap for frequent actions | ✅ PASS |
| Quick access improves efficiency (U-06) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 3

---

### 11.2 Learning and Onboarding Testing (U-02)

#### Test Case 11.2.1: Tutorial on First Launch

- **Priority:** LOW
- **Related Requirements:** U-02
- **Fit Criteria:** Tutorial or guide should appear on the first login and should be accessible at any time

| Expected Result | Pass/Fail |
|---|---|
| Tutorial/guide appears on first login | ❌ Not Implemented |
| Tutorial explains app's purpose and features | ❌ Not Implemented |
| Tutorial is brief (2-3 minutes) | ❌ Not Implemented |
| Tutorial can be skipped if user chooses | ❌ Not Implemented |
| Tutorial accessible anytime from settings (U-02) | ❌ Not Implemented |
| Tutorial helps users understand app | ❌ Not Implemented |

> **Note:** A first-launch tutorial was planned as part of requirement U-02 but was not implemented in the current version due to time constraints. The app's intuitive navigation and simple UI design were sufficient for users to onboard without guidance, as reflected in the UAT survey results where Navigation received a perfect 5.0 score. A tutorial feature is identified as a priority improvement for future development.

---

### 11.3 Understandability Testing (U-04)

#### Test Case 11.3.1: Clear and Friendly Language

- **Priority:** MEDIUM
- **Related Requirements:** U-04
- **Fit Criteria:** All error messages should be easy to understand and written in clear language

**Test Steps:**
1. Trigger various error scenarios:
   - Try to create habit with empty name
   - Attempt offline sync
   - Try invalid login
2. Read each error message
3. Evaluate clarity and friendliness

| Expected Result | Pass/Fail |
|---|---|
| All error messages use clear, simple language (meets U-04 fit criteria) | ✅ PASS |
| Error messages are friendly in tone | ✅ PASS |
| Messages explain what went wrong | ✅ PASS |
| Messages suggest how to fix issue | ✅ PASS |
| No technical language in user-facing text | ✅ PASS |
| Language is welcoming and helpful (U-04) | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** February 3

---

### 11.4 Accessibility Testing (U-05)

#### Test Case 11.4.1: Readable Fonts and Clear Contrast

- **Priority:** MEDIUM
- **Related Requirements:** U-05
- **Fit Criteria:** Users should be able to read text clearly, even with device settings for larger text

**Test Steps:**
1. Review app fonts and sizes
2. Check color contrast ratios
3. Enable device "Large Text" setting (150%, 200%)
4. Open app and verify text readability

| Expected Result | Pass/Fail |
|---|---|
| Fonts are readable | ✅ PASS |
| Color contrast meets WCAG standards (>= 4.5:1) | ✅ PASS |
| Text scales correctly with device settings | ✅ PASS |
| Users can read clearly even with larger text enabled (meets U-05 fit criteria) | ✅ PASS |
| No text cut off or overlapping | ✅ PASS |
| App remains usable with large text | ✅ PASS |

**Actual Results:** PASS
**Executed By:** Marina Skegro
**Execution Date:** March 10

---

## 12. User Acceptance Testing (UAT)

### 12.1.1 UAT Overview

- **Duration:** 1-2 weeks
- **Participants:** 5-10 real users
- **Purpose:** Validate app meets user needs in real-world scenarios

### 12.1.2 UAT Metrics

| Metric | Target | Measurement |
|---|---|---|
| Daily Active Users | >= 70% of UAT participants use app daily | Firebase Analytics |
| Habit Completion Rate | >= 60% of created habits completed regularly | Firestore data |
| System Usability Scale (SUS) | >= 68 (above average) | Post-UAT survey |

### 12.1.3 UAT Success Criteria

| Success Criteria | Pass/Fail |
|---|---|
| SUS score ≥ 68 | ✅ PASS |
| >= 70% of participants would continue using app | ✅ PASS |
| No critical (P0) bugs reported | ✅ PASS |
| Average feature satisfaction >= 3.5/5.0 | ✅ PASS |
| >= 50% daily active usage rate | ✅ PASS |

---

### 12.1.4 User Acceptance Testing Survey

**Survey Administration:**
- **Timing:** End of Week 2 of UAT (after 1-2 weeks of daily usage)
- **Method:** Google Forms or printed questionnaire
- **Duration:** 10-15 minutes to complete
- **Anonymous:** Participants may remain anonymous if preferred

---

#### GAMIFIED HABIT TRACKER — USER ACCEPTANCE TESTING SURVEY

*Thank you for participating in the User Acceptance Testing for the Gamified Habit Tracker app called Habit Love! Your honest feedback is essential to improving the app. This survey should take approximately 10-15 minutes to complete.*

---

**Part A: Background Information**

Participant: __________

How many days did you use the app during the testing period?
- [ ] 1-3 days
- [ ] 4-7 days
- [ ] 8-10 days
- [ ] 11-14 days

How many habits did you create in the app?
- [ ] 1-2 habits
- [ ] 3-5 habits
- [ ] 6-10 habits
- [ ] More than 10 habits

What type of device did you use?
- [ ] iPhone
- [ ] Samsung
- [ ] Google Pixel
- [ ] OnePlus
- [ ] Other Android: __________

Android version:
- [ ] Android 8-9
- [ ] Android 10-11
- [ ] Android 12+
- [ ] Don't know

---

**Part B: System Usability Scale (SUS)**

*For each statement below, please rate your level of agreement on a scale from 1 to 5:*
*1 = Strongly Disagree | 2 = Disagree | 3 = Neutral | 4 = Agree | 5 = Strongly Agree*

| # | Statement | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|---|
| 1 | I think I would like to use this app frequently | | | | | |
| 2 | I found the app unnecessarily complex | | | | | |
| 3 | I thought the app was easy to use | | | | | |
| 4 | I think I would need support to be able to use this app | | | | | |
| 5 | I found the various functions in this app were well integrated | | | | | |
| 6 | I thought there was too much inconsistency in this app | | | | | |
| 7 | I would imagine that most people would learn to use this app very quickly | | | | | |
| 8 | I found the app very cumbersome to use | | | | | |
| 9 | I felt very confident using the app | | | | | |
| 10 | I needed to learn a lot of things before I could get going with this app | | | | | |

> **SUS Scoring Instructions (for researcher):**
> - For odd-numbered items (1, 3, 5, 7, 9): Score = rating - 1
> - For even-numbered items (2, 4, 6, 8, 10): Score = 5 - rating
> - Sum all scores and multiply by 2.5
> - Result is SUS score out of 100
> - Target: >= 68 (above average)

---

**Part C: Feature Satisfaction**

*Please rate your satisfaction with each feature on a scale from 1 to 5:*
*1 = Very Dissatisfied | 2 = Dissatisfied | 3 = Neutral | 4 = Satisfied | 5 = Very Satisfied | N/A = Did not use*

| Feature | 1 | 2 | 3 | 4 | 5 | N/A |
|---|---|---|---|---|---|---|
| Habit Creation | | | | | | |
| Habit Management | | | | | | |
| XP System | | | | | | |
| Streak Tracking | | | | | | |
| Achievement Badges | | | | | | |
| Progress Analytics | | | | | | |
| Notifications/Reminders | | | | | | |
| Data Synchronization | | | | | | |
| User Interface | | | | | | |
| Navigation | | | | | | |
| Light/Dark Mode | | | | | | |

**Average Feature Satisfaction Score:** ______ / 5.0
**Target:** >= 4.0/5.0

---

**Part D: Net Promoter Score (NPS)**

*How likely are you to recommend this app to a friend or colleague who wants to build better habits?*
*0 = Not at all likely | 10 = Extremely likely*

| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

---

**Part E: Motivation and Engagement**

Did the gamification features (XP, streaks, badges) motivate you to complete your habits more consistently?
- [ ] Yes, significantly
- [ ] Yes, somewhat
- [ ] Not really
- [ ] No, not at all
- [ ] I don't know

Which gamification feature did you find MOST motivating?
- [ ] XP (Experience Points)
- [ ] Streaks (consecutive days)
- [ ] Achievement Badges
- [ ] Progress Analytics/Graphs
- [ ] None were motivating
- [ ] Other: __________

Which gamification feature did you find LEAST motivating?
- [ ] XP (Experience Points)
- [ ] Streaks (consecutive days)
- [ ] Achievement Badges
- [ ] Progress Analytics/Graphs
- [ ] All were motivating
- [ ] Other: __________

Would you continue using this app after the testing period ends?
- [ ] Yes, definitely
- [ ] Yes, probably
- [ ] Maybe
- [ ] Probably not
- [ ] Definitely not

> **Target:** >= 70% answer "Yes, definitely" or "Yes, probably"

---

**Part F: App Performance**

How would you rate the app's performance and speed?
- [ ] Excellent - Very fast and responsive
- [ ] Good - Generally fast with minor delays
- [ ] Acceptable - Some noticeable delays
- [ ] Poor - Frequently slow
- [ ] Very Poor - Constantly lagging

Did you experience any crashes or freezes?
- [ ] No, never
- [ ] Yes, once
- [ ] Yes, 2-3 times
- [ ] Yes, 4-5 times
- [ ] Yes, more than 5 times

If you experienced crashes, when did they occur?
- [ ] Did not experience crashes
- [ ] When opening the app
- [ ] When creating a habit
- [ ] When completing a habit
- [ ] When viewing analytics
- [ ] When syncing data
- [ ] Other: __________

---

**Part G: Open-Ended Feedback**

What did you LIKE MOST about the Gamified Habit Tracker?

> _______________________________________________

What did you LIKE LEAST about the Gamified Habit Tracker?

> _______________________________________________

What feature or improvement would make this app MORE useful for you?

> _______________________________________________

Did you encounter any bugs or issues? If yes, please describe:

> _______________________________________________

Is there anything else you'd like to share about your experience with the app?

> _______________________________________________

---

**Part H: Comparison (Optional)**

Have you used other habit tracking apps before?
- [ ] Yes
- [ ] No

If yes, which apps have you used?
- [ ] Habitica
- [ ] Streaks
- [ ] Habit Tracker
- [ ] Loop Habit Tracker
- [ ] Productive
- [ ] Way of Life
- [ ] Other: __________

How does Habit Love compare to other habit apps you've used?
- [ ] Much better
- [ ] Somewhat better
- [ ] About the same
- [ ] Somewhat worse
- [ ] Much worse
- [ ] Haven't used other apps

---

*Thank you for completing this survey! Your feedback is invaluable in making the Gamified Habit Tracker the best it can be. If you have any additional comments or would like to discuss your experience further, please contact Marina Skegro.*

**Survey Completion Date:** __________

---

### 12.1.5 UAT Survey Analysis

#### Feature Satisfaction Breakdown

| Feature | Avg Score | Notes |
|---|---|---|
| Habit Creation | 4.8 / 5.0 | Users found habit creation intuitive and straightforward. Minor suggestions for additional customization options. |
| Habit Management | 4.8 / 5.0 | Managing habits was clear and easy to use. Users appreciated the swipe-to-delete functionality. |
| XP System | 5.0 / 5.0 | Users found the XP rewards motivating and enjoyable. |
| Streak Tracking | 5.0 / 5.0 | Users responded very positively to streak tracking as a motivational tool. |
| Achievement Badges | 4.5 / 5.0 | Well received overall. Some users suggested adding more badge variety and unlock conditions. |
| Progress Analytics | 4.7 / 5.0 | Users appreciated the visual charts and calendar view. Some requested more detailed statistics. |
| Data Sync | 5.0 / 5.0 | Firebase sync was seamless and reliable across sessions with no reported data loss. |
| UI Design | 4.8 / 5.0 | The purple gradient theme was praised for being visually appealing and modern. |
| Navigation | 5.0 / 5.0 | Bottom navigation bar was intuitive and users found all screens easy to access. |
| Themes | 4.6 / 5.0 | Users liked the overall aesthetic. Some requested additional color theme options in future versions. |

#### Key Findings

**Strengths (What users liked most):**
The XP system, streak tracking, data sync, and navigation all received perfect 5.0 scores, indicating users found the gamification elements highly motivating and the app reliable and easy to navigate. The purple gradient UI design was consistently praised for its modern and visually appealing aesthetic.

**Weaknesses (What users liked least):**
Achievement badges received the lowest score at 4.5, with users noting they would like more variety in badge types and unlock conditions. Themes also scored slightly lower at 4.6, with users expressing interest in additional color customization options.

**Critical Bugs Reported:**
No critical bugs were reported during UAT testing. The app performed stably across all tested features with no crashes or data loss observed.

**Suggested Improvements:**
- Add more achievement badge varieties and unlock conditions
- Introduce additional color themes and personalization options
- Expand progress analytics with more detailed statistics and filtering options
- Add more habit customization options during habit creation
- Implement push notification reminders for habit completion
- Consider adding social or sharing features in a future version

---

## 12.2 Bug Tracking and Defect Management

### 12.2.1 Bug Severity Levels

**P0 - Critical:**
- App crashes on launch
- Cannot create or complete habits
- Data loss or corruption
- Response: Fix within 24 hours
- Release: CANNOT release with P0 bugs

**P1 - High:**
- XP calculation errors
- Streak tracking broken
- Sync failures
- Response: Fix within 2-3 days
- Release: Should NOT release with P1 bugs

**P2 - Medium:**
- UI glitches
- Minor calculation errors
- Response: Fix before release if time allows
- Release: Can release with documented P2 bugs

**P3 - Low:**
- Cosmetic issues
- Enhancement requests
- Response: Fix in future updates
- Release: Can release with P3 bugs

---

### Release Criteria

*ALL must be met:*

| Release Criteria | Pass/Fail |
|---|---|
| All HIGH priority requirements working (F-01, F-02, F-03, F-07, P-01, P-02, P-03, P-07, P-08, S-01, S-02, S-04, S-05, U-01, M-01, M-02) | ✅ PASS |
| Zero P0 bugs | ✅ PASS |
| Zero P1 bugs | ✅ PASS |
| Unit test coverage >= 70% | ✅ PASS |
| Dashboard loads within 3-5 seconds (P-01) | ✅ PASS |
| App supports 50 habits (P-06) | ✅ PASS |
| Data syncs across devices (F-07) | ✅ PASS |
| XP and streak calculations accurate (P-07) | ✅ PASS |
| No crashes on force-close (P-08) | ✅ PASS |
| Only authenticated users access data (S-01) | ✅ PASS |
| SUS score >= 68 | ✅ PASS |
| Professor Henderson's approval obtained | ✅ PASS |
