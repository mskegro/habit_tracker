// habit_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';


class HabitProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _habits = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get habits => _habits;
  bool get isLoading => _isLoading;

  Future<void> loadHabits() async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('habits')
          .where('userId', isEqualTo: user.uid)
          .where('isActive', isEqualTo: true)
          .get();

      _habits = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createHabit(Map<String, dynamic> habitData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      habitData['userId'] = user.uid;
      habitData['createdAt'] = FieldValue.serverTimestamp();
      habitData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('habits').add(habitData);
      await loadHabits();
    } catch (e) {
      print('Error creating habit: $e');
      rethrow;
    }
  }

  Future<void> completeHabit(String habitId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final habitDoc = await _firestore.collection('habits').doc(habitId).get();
      final habitData = habitDoc.data()!;

      final xpEarned = habitData['xpValue'] ?? 10;
      final currentStreak = habitData['currentStreak'] ?? 0;

      // Create completion record
      await _firestore.collection('completions').add({
        'habitId': habitId,
        'userId': user.uid,
        'completedAt': FieldValue.serverTimestamp(),
        'date': DateTime.now().toIso8601String().split('T')[0],
        'xpEarned': xpEarned,
        'streakOnCompletion': currentStreak + 1,
      });

      // Update habit
      await _firestore.collection('habits').doc(habitId).update({
        'currentStreak': currentStreak + 1,
        'longestStreak': currentStreak + 1 > (habitData['longestStreak'] ?? 0)
            ? currentStreak + 1
            : habitData['longestStreak'],
        'totalCompletions': (habitData['totalCompletions'] ?? 0) + 1,
        'lastCompletedAt': FieldValue.serverTimestamp(),
      });

      // Update user XP
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data()!;
      final newTotalXP = (userData['totalXP'] ?? 0) + xpEarned;

      await _firestore.collection('users').doc(user.uid).update({
        'totalXP': newTotalXP,
        'totalHabitsCompleted': (userData['totalHabitsCompleted'] ?? 0) + 1,
      });

  await _firestore.collection('users').doc(user.uid).update({
  'totalXP': newTotalXP,
  'totalHabitsCompleted': (userData['totalHabitsCompleted'] ?? 0) + 1,
});

print('🔍 About to check achievements for user: ${user.uid}');
try {
  final firestoreService = FirestoreService();
  final newAchievements = await firestoreService.checkAndUnlockAchievements(user.uid);
  print('✅ Finished checking achievements. Found ${newAchievements.length} new ones');
} catch (e) {
  print('❌ ERROR checking achievements: $e');
}

await loadHabits();
      await loadHabits();
    } catch (e) {
      print('Error completing habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _firestore.collection('habits').doc(habitId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadHabits();
    } catch (e) {
      print('Error deleting habit: $e');
      rethrow;
    }
  }
}
