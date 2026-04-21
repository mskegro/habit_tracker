# Proposal

Student Name: Marina Skegro
Degree and Major: Bachelor of Science in Computer Science
Project Advisor Name: Professor Julie Henderson
Expected Graduation Date: May 2026

# Problem Statement

Developing and maintaining productive habits is a challenge for many individuals. The ideal scenario would be a system that seamlessly integrates into daily life, motivates users, and encourages habit formation through engaging techniques. Traditional habit-tracking apps lack dynamic motivation, making it easy for users to lose interest and abandon their progress.

The problem is that users struggle with long-term habit adherence due to a lack of consistent motivation and engagement. Studies suggest that gamification can significantly improve user retention and motivation by incorporating elements like rewards, progress tracking, and competition. However, many existing habit trackers fail to effectively utilize gamification principles, leading to reduced user engagement.

A gamified habit tracker mobile app will solve this problem by combining habit tracking with game-like mechanics such as XP (experience points), achievements, streaks, and social features. This approach will encourage consistent behavior while making the habit-forming process enjoyable and rewarding. By integrating these mechanics, users will be more likely to stick with their habits, leading to improved productivity and well-being.

# Project Description

The Gamified Habit Tracker will be a mobile application that allows users to set, track, and maintain habits while earning rewards and achievements for their progress. Users will accumulate XP for completing habits, level up over time, and maintain streaks to build consistency. The app will feature a visually appealing dashboard, analytics to show progress trends, and cloud-based storage so users can sync their data across multiple devices.

Key Features:

* User Authentication (Email login)
* Habit creation and customization
* XP, streaks, and level-up mechanics
* Achievement badges for milestones
* Progress analytics and reports

## Libraries, Packages, Development Kits, etc.

* Flutter SDK - UI development
* Firebase Authentication - User login and authentication
* Cloud Firestore - Real-time NoSQL database for storing habits and progress
* Provider - State management for managing app-wide data
* Flutter Local Notifications - Planned for future implementation
* fl_chart - Progress analytics charts
* flutter_colorpicker - Custom habit color selection
* confetti - Habit completion animations
* lottie - UI animations
* shared_preferences - Local data persistence
* path_provider - Local file export
* intl - Date formatting
* uuid - Unique ID generation

## Additional Software/Equipment Needed

* VS Code - Development environment
* GitHub - Version control
* macOS desktop for testing

## Personal Motivation

My love for technology and its ability to enhance daily life is what inspired me to create a gamified habit tracker. As a student of computer science, I have always found it fascinating how software can improve user experiences, promote positive behaviour, and increase productivity. My interests in user-centered design and mobile development are well-suited to this project, which will enable me to investigate creative approaches to assisting people in forming and sustaining healthy behaviours. Personal experiences and observations of how challenging it may be to form persistent routines served as the inspiration for this project. Motivation is a problem for many people, particularly when establishing long-term healthy habits. Through the use of gamification components like challenges, progress monitoring, and rewards, I hope to make developing new habits more sustainable and enjoyable.

This project also gives me the chance to practice and improve my technical abilities in the creation of mobile applications. Working with modern programming frameworks, integrating databases for user progress tracking, and creating a smooth user experience that encourages interaction are all made possible by it. In addition to the technical side, I am interested in gaining skills in design thinking, demand analysis, and project management, all of which are essential for my future work in software development. My ultimate objective is to develop an application that will improve my comprehension of software engineering concepts and offer genuine benefits to individuals looking to track their habits and better their lives. This project is a significant milestone in my development career and demonstrates my dedication to creating technology that inspires and empowers others.

Additionally, this project serves as an opportunity to apply and refine my technical skills in mobile application development. It will enable me to work with modern development frameworks, integrate databases for user progress tracking, and implement a seamless user interface that fosters engagement. Beyond the technical aspect, I am eager to gain experience in project management, requirement analysis, and iterative design, all of which are crucial for my future career in software development.

Ultimately, my goal is to create an application that enhances my understanding of software engineering principles and provides real value to users seeking to improve their lives through habit tracking. This project represents a meaningful step in my journey as a developer and my commitment to building technology that empowers and motivates people.

## Outline of Future Research Efforts

To complete this project, I will:

* Research gamification techniques for habit formation
* Study best practices in UI/UX design for mobile applications
* Optimize Firebase Firestore queries for efficiency
* Test and refine habit-tracking mechanics to ensure user engagement
* Gather feedback through user testing to improve app features

## Expected Deliverables

* Fully functional mobile app (macOS desktop, Android & iOS planned for future)
* Source code repository with documentation
* User feedback and iteration logs

# Schedule

| Week | Dates | Tasks |
|---|---|---|
| **Week 1** | Sep 16–22 | Install Flutter, VS Code, Git. Set up GitHub repo. Create folders for Projects, Assets, Firebase. Plan app architecture and navigation. |
| **Week 2** | Sep 23–29 | Implement user login/register (email). Set up Firestore user collection. Basic UI for login, signup, home screen. |
| **Week 3** | Sep 30–Oct 6 | Habit creation, editing, deletion. Save habits in Firestore. Habit list UI. |
| **Week 4** | Oct 7–13 | Implement XP points for habits. Track streaks (consecutive days). Update Firestore automatically. |
| **Week 5** | Oct 14–20 | Add achievement badges for milestones. Implement a leveling system. Display badges and levels in profile. |
| **Week 6** | Oct 21–27 | Add local notifications for offline. Allow users to set reminder times. |
| **Week 7** | Oct 28–Nov 3 | Implement analytics screen. Show graphs: weekly/monthly XP and streaks. Use Flutter chart library. |
| **Week 8** | Nov 4–10 | Refine dashboard, habit cards, colors, fonts. Add animations for XP and habit completion. |
