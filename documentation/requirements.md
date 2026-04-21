# Requirements Document

**Project Name:** Gamified Habit Tracker
**Student Name:** Marina Skegro
**Degree and Major:** Bachelor of Science in Computer Science
**Project Advisor Name:** Professor Julie Henderson
**Expected Graduation Date:** May 2026

---

## 1. Functional Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| F-01 | Functional | Users can create and customize habits with names, descriptions, and recurrence settings. | Users need flexibility to track various habits. | The user should be able to create at least five habits during a session. | High | None |
| F-02 | Functional | Users earn experience points (XP) for completing habits. | Gamification motivates users to engage with the app. | XP should update immediately after habit completion. | High | F-01 |
| F-03 | Functional | Users can track their habit streaks. | Streak tracking encourages consistent habit formation. | The app should display streak count for each habit. | High | F-01 |
| F-04 | Functional | Users can unlock achievement badges upon reaching milestones. | Badges encourage long-term habit tracking. | Achievements should appear in the user profile when unlocked. | Medium | F-03 |
| F-05 | Functional | Users can view habit progress analytics. | Visualizing progress motivates habit consistency. | Show simple progress graphs, such as weekly or daily trends. | Medium | F-01 |
| F-06 | Functional | Users can receive habit reminders via notifications. | Reminders improve consistency but are not essential for initial release. | The notification should trigger at the set time, if they are enabled. | Low | F-01 |
| F-07 | Functional | Users can sync data across multiple devices. | Data should be accessible across different devices. | Data should sync on a different logged-in device. | High | None |

---

## 2. Look and Feel Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| LF-01 | Appearance | The app should have a clean, user-friendly interface. | Enhances user experience with a simple, pleasant look. | Should have a clear layout with easy-to-read fonts and consistent color schemes. | Medium | None |
| LF-02 | Style | Include basic animations for XP gain and habit completion. | Adds a playful touch to gamification. | Display a simple animation upon XP increase or habit completion. | Low | F-02, F-04 |

---

## 3. Usability Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| U-01 | Ease of Use | The app should have a simple and intuitive navigation. | Reduces complexity and enhances the user experience. | Users should be able to perform the main actions without confusion. | High | None |
| U-02 | Learning | Provide a brief tutorial or guide on the first launch of the app. | Helps new users understand the app's purpose and features. | Tutorial or guide should appear on the first login and should be accessible at any time. | Medium | F-01 |
| U-03 | Personalization and Internationalization | Allow users to choose light or dark mode. | Supports comfort and accessibility for a wider user base. | Users should be able to switch themes in the settings menu. | Medium | None |
| U-04 | Understandability and Politeness | Use clear and friendly language throughout the interface. | Improves communication and makes the app feel more welcoming. | All error messages should be easy to understand and written in clear language. | Medium | None |
| U-05 | Accessibility | The app should use readable fonts, clear contrast, and support larger system text sizes. | Improves usability for users with visual preferences or impairments. | Users should be able to read text clearly, even with device settings for larger text. | Medium | None |
| U-06 | Convenience | The app should allow quick access to frequently used features from the home screen. | Improves user efficiency and encourages consistent use. | Users should be able to access habit tracking and progress with no more than one tap from the dashboard. | Medium | None |

---

## 4. Performance Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| P-01 | Speed and Latency | The app should load the main dashboard within 3-5 seconds. | Ensures a smooth user experience. | Measure load time with Firebase profiling tools. | High | None |
| P-02 | Scalability | The app should handle an increasing amount of data and user activities without performance degradation. | Ensures smooth performance as app usage grows. | Performance tests should show that data processing, syncing, and UI responsiveness remain stable. | High | None |
| P-03 | Robustness | The app should automatically sync data when network connectivity is restored. | Ensures data integrity during connectivity issues. | Sync data once the network is available after the connection is restored. | High | F-07 |
| P-04 | Reliability and Availability | The app should be usable 95% of the time during testing. | Ensures that users can access the app consistently. | Test uptime during repeated simulated sessions and check for crashes or loading issues. | Medium | None |
| P-05 | Longevity | The app should be easy to update manually. | Allows for future improvements. | Can replace files and rebuild the app without errors. | Medium | None |
| P-06 | Capacity | The app should support up to 50 stored habits per user without slowing down. | Ensures usability without performance drops. | Test response time while interacting with 50 habits. | Medium | F-01 |
| P-07 | Precision or Accuracy | Habit streaks and XP calculations should be accurate and updated correctly. | Avoids errors in gamification logic and user stats. | Test data consistency by completing and undoing habits multiple times. | High | F-02, F-03 |
| P-08 | Safety-Critical | The app should not crash or corrupt data when suddenly closed. | Prevents data loss and ensures the safety of user inputs. | Simulate force-closing the app and check for saved state and no corrupted data. | High | F-01, F-07 |

---

## 5. Maintainability Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| M-01 | Version Control | Use version control for source code management. | Tracks changes and improves collaboration. | Code should be maintained on GitHub. | High | None |
| M-02 | Data Saving | Save user data when habits are marked or the screen is exited. | Prevents accidental loss. | Data appears correctly when the app is reopened. | High | None |

---

## 6. Security Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| S-01 | Integrity | Use Firebase with secure Firestore rules to protect user data. | Protects sensitive information. | Only authenticated users can access their data. | High | None |
| S-02 | Access | Implement Google (and optionally Email) login using Firebase. | Easy and secure access. | Users can log in using Google. | High | None |
| S-03 | Audit | Track last login and recent habit changes per user. | Basic user activity tracking. | Visible in Firestore under each user profile. | Low | None |
| S-04 | Privacy | Add a setting toggle for data-sharing consent. | Ensures user privacy. | Toggle exists in the settings screen. | High | None |
| S-05 | Immunity | Use Firestore rules to restrict access to authorized users only. | Prevents unauthorized access. | Unauthorized access attempts return permission denied. | High | S-01 |

---

## 7. Cultural Requirements

| ID | Type | Description | Rationale | Fit Criterion | Priority | Dependencies |
|---|---|---|---|---|---|---|
| C-01 | Emoji Localization | The app should have culturally neutral or globally recognized emojis in rewards. | Avoids emojis that may be offensive or misunderstood in some cultures. | Only culturally safe emojis are used across all app messages. | Medium | None |
| C-02 | Time Format | Let users choose between 12-hour and 24-hour clock formats. | Time is displayed differently in different parts of the world. | Users can toggle time format in settings. | Low | None |
| C-03 | Color Sensitivity | Avoid colors with strong cultural symbolism. | Prevents confusion or miscommunication due to color meanings. | UI color palette avoids culturally sensitive combinations. | Low | None |
