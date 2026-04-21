import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamified_habit_tracker/widgets/bottom_nav_bar.dart';
import 'package:gamified_habit_tracker/screens/settings/privacy_policy_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _notificationsEnabled = true;
  bool _dataShareConsent = false;
  String _timeFormat = '12h';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>? ?? {};

        setState(() {
          _notificationsEnabled = settings['notificationsEnabled'] ?? true;
          _dataShareConsent = settings['dataShareConsent'] ?? false;
          _timeFormat = settings['timeFormat'] ?? '12h';
        });
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'settings.$key': value,
      });
    } catch (e) {
      print('Error updating setting: $e');
    }
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .delete();

      final habitsSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('userId', isEqualTo: user!.uid)
          .get();

      for (var doc in habitsSnapshot.docs) {
        await doc.reference.delete();
      }

      final completionsSnapshot = await FirebaseFirestore.instance
          .collection('completions')
          .where('userId', isEqualTo: user!.uid)
          .get();

      for (var doc in completionsSnapshot.docs) {
        await doc.reference.delete();
      }

      await user!.delete();

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    }
  }

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
                      'Settings',
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
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Account Section
                      const Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildAccountInfo(),

                      const SizedBox(height: 32),

                      const SizedBox(height: 32),

                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSettingTile(
                        icon: Icons.notifications,
                        title: 'Enable Notifications',
                        subtitle: 'Receive reminders for your habits',
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                            _updateSetting('notificationsEnabled', value);
                          },
                          activeColor: const Color.fromARGB(255, 172, 135, 203),
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSettingTile(
                        icon: Icons.schedule,
                        title: 'Time Format',
                        subtitle: _timeFormat == '12h' ? '12-hour' : '24-hour',
                        trailing: DropdownButton<String>(
                          value: _timeFormat,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: '12h', child: Text('12h')),
                            DropdownMenuItem(value: '24h', child: Text('24h')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _timeFormat = value);
                              _updateSetting('timeFormat', value);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Privacy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSettingTile(
                        icon: Icons.share,
                        title: 'Data Sharing',
                        subtitle: 'Allow anonymous usage analytics',
                        trailing: Switch(
                          value: _dataShareConsent,
                          onChanged: (value) {
                            setState(() => _dataShareConsent = value);
                            _updateSetting('dataShareConsent', value);
                          },
                          activeColor: const Color.fromARGB(255, 172, 61, 203),
                        ),
                      ),

                      _buildSettingTile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        subtitle: 'View our privacy policy',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      const Text(
                        'Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),

                     _buildSettingTile(
                        icon: Icons.download,
                        title: 'Export Data',
                        subtitle: 'Download your habit data',
                        onTap: () async {
                          if (user == null) return;

                          try {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Preparing your data...')),
                            );

                            final habitsSnapshot = await FirebaseFirestore.instance
                                .collection('habits')
                                .where('userId', isEqualTo: user!.uid)
                                .get();

                            final completionsSnapshot = await FirebaseFirestore.instance
                                .collection('completions')
                                .where('userId', isEqualTo: user!.uid)
                                .get();

                            final userDoc = await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user!.uid)
                                .get();
                            final userData = userDoc.data() ?? {};

                            final buffer = StringBuffer();

                            buffer.writeln('=== HABIT LOVE DATA EXPORT ===');
                            buffer.writeln('Exported: ${DateTime.now()}');
                            buffer.writeln('User: ${user!.displayName ?? 'N/A'}');
                            buffer.writeln('Email: ${user!.email ?? 'N/A'}');
                            buffer.writeln('Level: ${userData['level'] ?? 1}');
                            buffer.writeln('Total XP: ${userData['totalXP'] ?? 0}');
                            buffer.writeln('Total Habits Completed: ${userData['totalHabitsCompleted'] ?? 0}');
                            buffer.writeln('Longest Streak: ${userData['longestStreak'] ?? 0}');
                            buffer.writeln('');

                            buffer.writeln('=== HABITS ===');
                            buffer.writeln('Name,Frequency,Created At,Is Active');
                            for (var doc in habitsSnapshot.docs) {
                              final data = doc.data();
                              buffer.writeln(
                                '${data['name'] ?? 'N/A'},'
                                '${data['frequency'] ?? 'N/A'},'
                                '${data['createdAt'] ?? 'N/A'},'
                                '${data['isActive'] ?? false}',
                              );
                            }
                            buffer.writeln('');

                            buffer.writeln('=== COMPLETIONS ===');
                            buffer.writeln('Habit Name,Date,XP Earned');
                            for (var doc in completionsSnapshot.docs) {
                              final data = doc.data();
                              buffer.writeln(
                                '${data['habitName'] ?? 'N/A'},'
                                '${data['date'] ?? 'N/A'},'
                                '${data['xpEarned'] ?? 0}',
                              );
                            }

                            // Save to file
                            final directory = await getApplicationDocumentsDirectory();
                            final fileName = 'habit_love_export_${DateTime.now().millisecondsSinceEpoch}.csv';
                            final file = File('${directory.path}/$fileName');
                            await file.writeAsString(buffer.toString());

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('✅ Data exported to: ${file.path}'),
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Export failed: $e')),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 32),

                      const Text(
                        'Danger Zone',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildSettingTile(
                        icon: Icons.logout,
                        title: 'Log Out',
                        subtitle: 'Sign out of your account',
                        iconColor: Colors.orange,
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                      ),

                      _buildSettingTile(
                        icon: Icons.delete_forever,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account and data',
                        iconColor: Colors.red,
                        onTap: _showDeleteAccountDialog,
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Gamified Habit Tracker',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Version 1.0.0',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Made with 💜 by Marina',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
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

  Widget _buildAccountInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 135, 63, 183),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user?.displayName?.substring(0, 1).toUpperCase() ?? '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color.fromARGB(255, 142, 78, 168)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color.fromARGB(255, 125, 36, 145),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing else if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
              ),
          ],
        ),
      ),
    );
  }
}