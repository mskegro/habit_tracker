import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamified_habit_tracker/widgets/bottom_nav_bar.dart';
import 'package:gamified_habit_tracker/widgets/purple_background.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late firebase_auth.User? user;

  @override
  void initState() {
    super.initState();
    user = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PurpleBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'Achievements\n& Levels',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final userData = snapshot.data!.data() as Map<String, dynamic>?;
                      final totalXP = ((userData?['totalXP'] ?? 0) as num).toInt();
                      final level = ((userData?['level'] ?? 1) as num).toInt();
                      final currentLevelXP = ((userData?['currentLevelXP'] ?? 0) as num).toInt();
                      final xpToNextLevel = ((userData?['xpToNextLevel'] ?? 100) as num).toInt();
                      final totalCompleted = ((userData?['totalHabitsCompleted'] ?? 0) as num).toInt();
                      final longestStreak = ((userData?['longestStreak'] ?? 0) as num).toInt();

                      final achievements = _getAchievements(
                        totalXP: totalXP,
                        level: level,
                        totalCompleted: totalCompleted,
                        maxStreak: longestStreak,
                      );

                      final unlockedCount = achievements.where((a) => a['unlocked'] == true).length;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLevelProgress(level, currentLevelXP, xpToNextLevel, totalXP),

                            const SizedBox(height: 24),

                            _buildLevelRoadmap(level),

                            const SizedBox(height: 32),

                            _buildProgressOverview(
                              unlockedCount,
                              achievements.length,
                            ),

                            const SizedBox(height: 32),

                            const Text(
                              'All Achievements',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: achievements.length,
                              itemBuilder: (context, index) {
                                final achievement = achievements[index];
                                final isUnlocked = achievement['unlocked'] as bool;
                                return _buildAchievementCard(achievement, isUnlocked);
                              },
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/achievements'),
    );
  }

  Widget _buildLevelProgress(int level, int currentLevelXP, int xpToNextLevel, int totalXP) {
    final progress = currentLevelXP / xpToNextLevel;
    final percentage = (progress * 100).toInt();
    final levelInfo = _getLevelInfo(level);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [levelInfo['color'] as Color, (levelInfo['color'] as Color).withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (levelInfo['color'] as Color).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level $level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${levelInfo['name']} ${levelInfo['icon']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  levelInfo['icon'],
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$currentLevelXP / $xpToNextLevel XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$percentage% to next level',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total XP: $totalXP',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelRoadmap(int currentLevel) {
    final allLevels = [
      {'level': 10, 'name': 'Transcendent', 'icon': '🌌', 'color': const Color(0xFF8B5CF6)},
      {'level': 9, 'name': 'Divine', 'icon': '✨', 'color': const Color(0xFFEC4899)},
      {'level': 8, 'name': 'Immortal', 'icon': '🌟', 'color': const Color(0xFFF59E0B)},
      {'level': 7, 'name': 'Mythic', 'icon': '🔥', 'color': const Color(0xFFEF4444)},
      {'level': 6, 'name': 'Legend', 'icon': '💎', 'color': const Color(0xFF06B6D4)},
      {'level': 5, 'name': 'Master', 'icon': '👑', 'color': const Color(0xFF8B5CF6)},
      {'level': 4, 'name': 'Champion', 'icon': '🏆', 'color': const Color(0xFFF59E0B)},
      {'level': 3, 'name': 'Achiever', 'icon': '⭐', 'color': const Color(0xFF10B981)},
      {'level': 2, 'name': 'Learner', 'icon': '🔰', 'color': const Color(0xFF06B6D4)},
      {'level': 1, 'name': 'Beginner', 'icon': '🌱', 'color': const Color(0xFF64748B)},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Level Roadmap',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          
          ...allLevels.map((levelData) {
            final level = levelData['level'] as int;
            final name = levelData['name'] as String;
            final icon = levelData['icon'] as String;
            final color = levelData['color'] as Color;
            final isCurrent = level == currentLevel;
            final isUnlocked = level <= currentLevel;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isUnlocked ? color : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(color: color, width: 3)
                          : null,
                      boxShadow: isCurrent
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        icon,
                        style: TextStyle(
                          fontSize: 24,
                          color: isUnlocked ? null : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Level $level',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                              ),
                            ),
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'CURRENT',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            color: isUnlocked ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (isUnlocked && !isCurrent)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF10B981),
                      size: 24,
                    )
                  else if (!isUnlocked)
                    const Icon(
                      Icons.lock,
                      color: Color(0xFFCBD5E1),
                      size: 24,
                    ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Map<String, dynamic> _getLevelInfo(int level) {
    if (level >= 10) return {'name': 'Transcendent', 'icon': '🌌', 'color': const Color(0xFF8B5CF6)};
    if (level >= 9) return {'name': 'Divine', 'icon': '✨', 'color': const Color(0xFFEC4899)};
    if (level >= 8) return {'name': 'Immortal', 'icon': '🌟', 'color': const Color(0xFFF59E0B)};
    if (level >= 7) return {'name': 'Mythic', 'icon': '🔥', 'color': const Color(0xFFEF4444)};
    if (level >= 6) return {'name': 'Legend', 'icon': '💎', 'color': const Color(0xFF06B6D4)};
    if (level >= 5) return {'name': 'Master', 'icon': '👑', 'color': const Color(0xFF8B5CF6)};
    if (level >= 4) return {'name': 'Champion', 'icon': '🏆', 'color': const Color(0xFFF59E0B)};
    if (level >= 3) return {'name': 'Achiever', 'icon': '⭐', 'color': const Color(0xFF10B981)};
    if (level >= 2) return {'name': 'Learner', 'icon': '🔰', 'color': const Color(0xFF06B6D4)};
    return {'name': 'Beginner', 'icon': '🌱', 'color': const Color(0xFF64748B)};
  }

  Widget _buildProgressOverview(int unlockedCount, int totalCount) {
    final percentage = totalCount > 0 ? (unlockedCount / totalCount * 100).toInt() : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 203, 141, 242), Color.fromARGB(255, 102, 191, 242)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 164, 57, 166).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievement Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Keep unlocking more!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: totalCount > 0 ? unlockedCount / totalCount : 0,
              minHeight: 8,
              backgroundColor: const Color.fromARGB(255, 219, 193, 227).withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 238, 224, 244)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$unlockedCount of $totalCount unlocked',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement, bool isUnlocked) {
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? const Color(0xFFF8FAFC) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? const Color.fromARGB(255, 208, 157, 252) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? _getRarityColor(achievement['rarity']).withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                achievement['icon'],
                style: TextStyle(
                  fontSize: 36,
                  color: isUnlocked ? null : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              achievement['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isUnlocked ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              achievement['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isUnlocked ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),

          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '+${achievement['xpReward']} XP',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF92400E),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Locked',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return const Color(0xFFEF4444);
      case 'epic':
        return const Color(0xFF8B5CF6);
      case 'rare':
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF10B981);
    }
  }

  List<Map<String, dynamic>> _getAchievements({
    required int totalXP,
    required int level,
    required int totalCompleted,
    required int maxStreak,
  }) {
    return [
      {
        'id': 'first_habit',
        'name': 'First Steps',
        'description': 'Create your first habit',
        'icon': '🎯',
        'xpReward': 10,
        'rarity': 'common',
        'unlocked': totalCompleted > 0,
      },
      {
        'id': 'first_completion',
        'name': 'Getting Started',
        'description': 'Complete your first habit',
        'icon': '✅',
        'xpReward': 25,
        'rarity': 'common',
        'unlocked': totalCompleted >= 1,
      },
      {
        'id': 'streak_3',
        'name': 'On a Roll',
        'description': 'Maintain a 3-day streak',
        'icon': '🔥',
        'xpReward': 50,
        'rarity': 'common',
        'unlocked': maxStreak >= 3,
      },
      {
        'id': 'streak_7',
        'name': 'Week Warrior',
        'description': 'Complete a 7-day streak',
        'icon': '💪',
        'xpReward': 100,
        'rarity': 'rare',
        'unlocked': maxStreak >= 7,
      },
      {
        'id': 'level_5',
        'name': 'Rising Star',
        'description': 'Reach level 5',
        'icon': '⭐',
        'xpReward': 75,
        'rarity': 'rare',
        'unlocked': level >= 5,
      },
      {
        'id': 'completions_25',
        'name': 'Dedicated',
        'description': 'Complete 25 habits',
        'icon': '🎖️',
        'xpReward': 150,
        'rarity': 'rare',
        'unlocked': totalCompleted >= 25,
      },
      {
        'id': 'streak_30',
        'name': 'Monthly Master',
        'description': 'Complete a 30-day streak',
        'icon': '👑',
        'xpReward': 300,
        'rarity': 'epic',
        'unlocked': maxStreak >= 30,
      },
      {
        'id': 'level_10',
        'name': 'Expert',
        'description': 'Reach level 10',
        'icon': '💎',
        'xpReward': 200,
        'rarity': 'epic',
        'unlocked': level >= 10,
      },
      {
        'id': 'completions_100',
        'name': 'Centurion',
        'description': 'Complete 100 habits',
        'icon': '🏆',
        'xpReward': 500,
        'rarity': 'epic',
        'unlocked': totalCompleted >= 100,
      },
      {
        'id': 'streak_100',
        'name': 'Unstoppable',
        'description': 'Complete a 100-day streak',
        'icon': '🌟',
        'xpReward': 1000,
        'rarity': 'legendary',
        'unlocked': maxStreak >= 100,
      },
      {
        'id': 'level_25',
        'name': 'Legend',
        'description': 'Reach level 25',
        'icon': '🔱',
        'xpReward': 750,
        'rarity': 'legendary',
        'unlocked': level >= 25,
      },
      {
        'id': 'completions_500',
        'name': 'Habit Master',
        'description': 'Complete 500 habits',
        'icon': '🎯',
        'xpReward': 2000,
        'rarity': 'legendary',
        'unlocked': totalCompleted >= 500,
      },
    ];
  }
}