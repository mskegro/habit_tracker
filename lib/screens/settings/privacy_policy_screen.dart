import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 140, 34, 170),
              Color.fromARGB(255, 210, 105, 226),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 233, 220, 238),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: April 1, 2026',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 102, 39, 138),
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildSection(
                        '1. Introduction',
                        'Welcome to Habit Love. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.',
                      ),

                      _buildSection(
                        '2. Data We Collect',
                        'We collect the following information when you use Habit Love:\n\n'
                        '• Name and email address (provided during account registration)\n'
                        '• Habit data including habit names, completion history, and streaks\n'
                        '• App usage data such as XP earned, level progress, and achievements\n'
                        '• Device information for app functionality purposes',
                      ),

                      _buildSection(
                        '3. How We Use Your Data',
                        'Your data is used solely to provide and improve the Habit Love experience:\n\n'
                        '• To create and manage your account\n'
                        '• To track and display your habit progress\n'
                        '• To calculate XP, levels, streaks, and achievements\n'
                        '• To personalize your in-app experience\n\n'
                        'We do not sell, trade, or rent your personal data to third parties.',
                      ),

                      _buildSection(
                        '4. Data Storage & Security',
                        'Your data is stored securely using Google Firebase, a trusted cloud platform provided by Google LLC. Firebase applies industry-standard encryption and security practices to protect your information.\n\n'
                        'We take reasonable measures to protect your data, but no method of transmission over the internet is 100% secure.',
                      ),

                      _buildSection(
                        '5. Third-Party Services',
                        'Habit Love uses the following third-party services:\n\n'
                        '• Google Firebase (Authentication & Database) — https://firebase.google.com\n'
                        '• Google Analytics (optional, anonymous usage data)\n\n'
                        'These services have their own privacy policies and data handling practices.',
                      ),

                      _buildSection(
                        '6. Your Rights',
                        'You have the right to:\n\n'
                        '• Access the personal data we hold about you\n'
                        '• Request correction of inaccurate data\n'
                        '• Delete your account and all associated data at any time via Settings → Delete Account\n'
                        '• Opt out of anonymous analytics via Settings → Privacy → Data Sharing',
                      ),

                      _buildSection(
                        '7. Data Deletion',
                        'You can permanently delete your account and all associated data at any time by navigating to Settings → Danger Zone → Delete Account. This action is irreversible and will remove all your habits, completions, and progress from our systems.',
                      ),

                      _buildSection(
                        '8. Children\'s Privacy',
                        'Habit Love is not directed at children under the age of 13. We do not knowingly collect personal information from children under 13. If you believe a child has provided us with personal information, please contact us.',
                      ),

                      _buildSection(
                        '9. Changes to This Policy',
                        'We may update this Privacy Policy from time to time. Any changes will be reflected in the app with an updated date at the top of this page. Continued use of the app after changes constitutes acceptance of the updated policy.',
                      ),

                      _buildSection(
                        '10. Contact Us',
                        'If you have any questions or concerns about this Privacy Policy or your data, please contact us at:\n\n'
                        '📧 mskegro@student.csuniv.edu\n\n'
                        'We will respond to your inquiry within a reasonable timeframe.',
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Text(
                          '© 2026 Habit Love. All rights reserved.',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 111, 20, 114),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 64, 39, 73),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
