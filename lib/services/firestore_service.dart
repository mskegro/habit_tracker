import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Check and unlock achievements for a user
  Future<List<Map<String, dynamic>>> checkAndUnlockAchievements(String userId) async {
    try {
      // Get user data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      
      if (userData == null) return [];

      final totalCompleted = ((userData['totalHabitsCompleted'] ?? 0) as num).toInt();
      final maxStreak = ((userData['longestStreak'] ?? 0) as num).toInt();
      final level = ((userData['level'] ?? 1) as num).toInt();

      // Get currently unlocked achievements
      final unlockedAchievements = List<String>.from(userData['unlockedAchievements'] ?? []);

      final allAchievements = _getAllAchievements(
        totalCompleted: totalCompleted,
        maxStreak: maxStreak,
        level: level,
      );

  final newlyUnlocked = <Map<String, dynamic>>[];

  print('📊 Checking achievements:');
  print('   totalCompleted: $totalCompleted, maxStreak: $maxStreak, level: $level');
  print('   Currently unlocked: $unlockedAchievements');

for (final achievement in allAchievements) {
  final id = achievement['id'] as String;
  final shouldBeUnlocked = achievement['unlocked'] as bool;
  final isAlreadyUnlocked = unlockedAchievements.contains(id);

  print('   $id: shouldUnlock=$shouldBeUnlocked, alreadyUnlocked=$isAlreadyUnlocked');

  if (shouldBeUnlocked && !isAlreadyUnlocked) {
    newlyUnlocked.add(achievement);
    unlockedAchievements.add(id);
  }
}

      // If there are new achievements, update Firestore and award XP
      if (newlyUnlocked.isNotEmpty) {
        int totalXPReward = 0;
        for (final achievement in newlyUnlocked) {
          totalXPReward += achievement['xpReward'] as int;
        }

        await _firestore.collection('users').doc(userId).update({
          'unlockedAchievements': unlockedAchievements,
          'totalXP': FieldValue.increment(totalXPReward),
          'currentLevelXP': FieldValue.increment(totalXPReward),
        });
        print('Saved to Firestore: $unlockedAchievements');

        print('🎉 Unlocked ${newlyUnlocked.length} new achievements! +$totalXPReward XP');
for (final ach in newlyUnlocked) {
  print('   ✨ ${ach['name']} (+${ach['xpReward']} XP)');
}

      }

      return newlyUnlocked;
    } catch (e) {
      print('Error checking achievements: $e');
      return [];
    }
  }

Future<void> checkAndResetStreaks(String userId) async {
  try {
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey = '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';

    // Get all active habits
    final habitsSnapshot = await _firestore
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .get();

    for (var habitDoc in habitsSnapshot.docs) {
      final habitData = habitDoc.data();
      final currentStreak = ((habitData['currentStreak'] ?? 0) as num).toInt();

      if (currentStreak == 0) continue;

      // Check if completed yesterday
      final yesterdayProgress = await _firestore
          .collection('habits')
          .doc(habitDoc.id)
          .collection('progress')
          .doc(yesterdayKey)
          .get();

      // Check if completed today
      final todayProgress = await _firestore
          .collection('habits')
          .doc(habitDoc.id)
          .collection('progress')
          .doc(todayKey)
          .get();

      final completedYesterday = yesterdayProgress.exists &&
          (yesterdayProgress.data()?['completed'] ?? false);
      final completedToday = todayProgress.exists &&
          (todayProgress.data()?['completed'] ?? false);

      // If not completed yesterday and not completed today, reset streak
      if (!completedYesterday && !completedToday) {
        await _firestore
            .collection('habits')
            .doc(habitDoc.id)
            .update({'currentStreak': 0});
        print('🔄 Reset streak for habit: ${habitData['name']}');
      }
    }
  } catch (e) {
    print('Error resetting streaks: $e');
  }
}
  List<Map<String, dynamic>> _getAllAchievements({
    required int totalCompleted,
    required int maxStreak,
    required int level,
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
