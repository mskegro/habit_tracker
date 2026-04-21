import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:gamified_habit_tracker/widgets/bottom_nav_bar.dart';
import 'package:gamified_habit_tracker/widgets/purple_background.dart';
import 'package:gamified_habit_tracker/screens/habits/habit_detail_screen.dart';
import 'package:gamified_habit_tracker/services/confetti_service.dart';
import 'dart:math' as math;
import 'package:gamified_habit_tracker/services/firestore_service.dart';
import 'package:gamified_habit_tracker/services/firestore_service.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  DateTime _selectedDate = DateTime.now();
  AnimationController? _bounceController;
  AnimationController? _animationController;
  Set<String> _completedHabitsWithConfetti = {};

  @override
  void initState() {
    super.initState();
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
      if (user != null) {
    FirestoreService().checkAndResetStreaks(user!.uid);
  }
  }

  @override
  void dispose() {
    _bounceController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade700,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (_animationController != null)
            AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedLinesPainter(_animationController!.value),
                  size: Size.infinite,
                );
              },
            ),
          
          PurpleBackground(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 200,
                      ),
                      child: Column(
                        children: [
                          _buildWeekCalendar(),
                          _buildHabitsList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentRoute: '/dashboard'),
      floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 320),
  child: FloatingActionButton.small(
    onPressed: () async {
      final result = await Navigator.pushNamed(context, '/create-habit');
      if (result == true) {
        setState(() {});
      }
    },
    backgroundColor: const Color.fromARGB(255, 152, 95, 183),
    child: const Icon(Icons.add, size: 20, color: Colors.white),
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final userName = userData?['displayName'] ?? 'User';
          final emoji = userData?['avatarEmoji'] ?? '😊';
          
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello, welcome back',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('habits')
                    .where('userId', isEqualTo: user?.uid)
                    .where('isActive', isEqualTo: true)
                    .snapshots(),
                builder: (context, habitSnapshot) {
                  if (!habitSnapshot.hasData || habitSnapshot.data!.docs.isEmpty) {
                    return const SizedBox();
                  }
                  
                  final habits = habitSnapshot.data!.docs;
                  final today = DateTime.now();
                  final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
                  
                  return StreamBuilder<List<DocumentSnapshot>>(
                    stream: Stream.fromFuture(
                      Future.wait(
                        habits.map((habit) => 
                          FirebaseFirestore.instance
                            .collection('habits')
                            .doc(habit.id)
                            .collection('progress')
                            .doc(dateKey)
                            .get()
                        ).toList()
                      )
                    ),
                    builder: (context, progressSnapshot) {
                      if (!progressSnapshot.hasData) {
                        return const SizedBox();
                      }
                      
                      int completedCount = 0;
                      int totalHabits = habits.length;
                      int overallStreak = 0;
                      
                      for (int i = 0; i < progressSnapshot.data!.length; i++) {
                        final progressDoc = progressSnapshot.data![i];
                        if (progressDoc.exists) {
                          final progressData = progressDoc.data() as Map<String, dynamic>?;
                          if (progressData?['completed'] == true) {
                            completedCount++;
                          }
                        }
                        
                        final habitData = habits[i].data() as Map<String, dynamic>;
                        final streak = ((habitData['currentStreak'] ?? 0) as num).toInt();
                        if (streak > overallStreak) overallStreak = streak;
                      }
                      
                      if (completedCount < totalHabits) {
                        return const SizedBox();
                      }
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              '$overallStreak',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 219, 148, 230),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeekCalendar() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;
          final isToday = date.day == today.day &&
              date.month == today.month &&
              date.year == today.year;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Column(
              children: [
                Text(
                  DateFormat('E').format(date).substring(0, 2),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(255, 196, 87, 229)
                        : (isToday ? const Color(0xFFFFE4E6) : Colors.transparent),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: const Color.fromARGB(255, 171, 70, 159), width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHabitsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('habits')
          .where('userId', isEqualTo: user?.uid)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📝', style: TextStyle(fontSize: 60)),
                const SizedBox(height: 16),
                const Text(
                  'No habits yet!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap + to create your first habit',
                  style: TextStyle(color: Color.fromARGB(255, 191, 102, 210)),
                ),
              ],
            ),
          );
        }

        final habits = snapshot.data!.docs;
        final morningHabits = <QueryDocumentSnapshot>[];
        final afternoonHabits = <QueryDocumentSnapshot>[];
        final eveningHabits = <QueryDocumentSnapshot>[];
        final anytimeHabits = <QueryDocumentSnapshot>[];

        for (var habit in habits) {
          final data = habit.data() as Map<String, dynamic>;
          final timeRange = (data['timeRange'] ?? 'Anytime').toString().toLowerCase();

          if (timeRange.contains('morning')) {
            morningHabits.add(habit);
          } else if (timeRange.contains('afternoon')) {
            afternoonHabits.add(habit);
          } else if (timeRange.contains('evening')) {
            eveningHabits.add(habit);
          } else {
            anytimeHabits.add(habit);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 100),
          child: Column(
            children: [
              if (morningHabits.isNotEmpty) ...[
                _buildTimeRangeHeader('Morning', '🌅'),
                ...morningHabits.map((habit) => _buildHabitCard(habit)),
                const SizedBox(height: 16),
              ],
              if (afternoonHabits.isNotEmpty) ...[
                _buildTimeRangeHeader('Afternoon', '☀️'),
                ...afternoonHabits.map((habit) => _buildHabitCard(habit)),
                const SizedBox(height: 16),
              ],
              if (eveningHabits.isNotEmpty) ...[
                _buildTimeRangeHeader('Evening', '🌙'),
                ...eveningHabits.map((habit) => _buildHabitCard(habit)),
                const SizedBox(height: 16),
              ],
              if (anytimeHabits.isNotEmpty) ...[
                _buildTimeRangeHeader('Anytime', '⏰'),
                ...anytimeHabits.map((habit) => _buildHabitCard(habit)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRangeHeader(String title, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(QueryDocumentSnapshot habitDoc) {
    final habitData = habitDoc.data() as Map<String, dynamic>;
    final habitId = habitDoc.id;
    
    return Dismissible(
      key: Key(habitId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Delete Habit?'),
            content: Text(
              'Are you sure you want to delete "${habitData['name']}"?\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        try {
          await FirebaseFirestore.instance
              .collection('habits')
              .doc(habitId)
              .delete();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${habitData['name']} deleted'),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          print('Error deleting habit: $e');
        }
      },
      child: _buildHabitCardContent(habitId, habitData),
    );
  }

  Widget _buildHabitCardContent(String habitId, Map<String, dynamic> habitData) {
    final colorHex = habitData['color'] ?? '#5B9BD5';
    final habitColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    
    return StreamBuilder<DocumentSnapshot>(
      stream: _getTodayProgressStream(habitId),
      builder: (context, progressSnapshot) {
        final progressData = progressSnapshot.data?.data() as Map<String, dynamic>?;
        final currentValue = ((progressData?['value'] ?? 0) as num).toDouble();
        final targetValue = ((habitData['targetValue'] ?? 1) as num).toDouble();
        final isCompleted = progressData?['completed'] ?? false;
        final progress = targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
        
        if (isCompleted && _bounceController != null && _bounceController!.status != AnimationStatus.completed) {
          if (!_completedHabitsWithConfetti.contains(habitId)) {
            _bounceController!.forward();
            _completedHabitsWithConfetti.add(habitId);
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailScreen(
                  habitId: habitId,
                  habitData: habitData,
                ),
              ),
            );
          },
          child: ScaleTransition(
            scale: isCompleted && _bounceController != null
                ? Tween<double>(begin: 1.0, end: 1.05).animate(
                    CurvedAnimation(
                      parent: _bounceController!,
                      curve: Curves.elasticOut,
                    ),
                  )
                : const AlwaysStoppedAnimation(1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: habitColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: habitColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: habitColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 60 * progress,
                                        decoration: BoxDecoration(
                                          color: habitColor.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        habitData['icon'] ?? '✓',
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habitData['name'] ?? 'Habit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isCompleted ? FontWeight.w800 : FontWeight.w600,
                                  color: const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (isCompleted)
                                Row(
                                  children: [
                                    Icon(Icons.check_circle, 
                                      color: habitColor, 
                                      size: 16
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Completed!',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: habitColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Text(
                                  '${currentValue.toInt()}/${targetValue.toInt()} ${habitData['unit'] ?? 'times'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (!isCompleted)
                          GestureDetector(
                            onTap: () => _quickCompleteHabit(habitId, habitData),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: habitColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: habitColor,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                color: habitColor,
                                size: 28,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: habitColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isCompleted)
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: habitColor,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _quickCompleteHabit(String habitId, Map<String, dynamic> habitData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final progressRef = FirebaseFirestore.instance
          .collection('habits')
          .doc(habitId)
          .collection('progress')
          .doc(dateKey);

      await progressRef.set({
        'value': habitData['targetValue'],
        'completed': true,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ConfettiService().playConfetti(context);

      final xpValue = ((habitData['xpValue'] ?? 10) as num).toInt();
      
      await FirebaseFirestore.instance.collection('completions').add({
        'userId': user.uid,
        'habitId': habitId,
        'habitName': habitData['name'] ?? 'Habit',
        'xpEarned': xpValue,
        'date': dateKey,
        'completedAt': FieldValue.serverTimestamp(),
      });

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final userData = userDoc.data() ?? {};
      int currentTotalXP = ((userData['totalXP'] ?? 0) as num).toInt();
      int currentLevelXP = ((userData['currentLevelXP'] ?? 0) as num).toInt();
      int currentLevel = ((userData['level'] ?? 1) as num).toInt();
      int xpToNextLevel = ((userData['xpToNextLevel'] ?? 100) as num).toInt();

      int newTotalXP = currentTotalXP + xpValue;
      int newCurrentLevelXP = currentLevelXP + xpValue;
      int newLevel = currentLevel;

      while (newCurrentLevelXP >= xpToNextLevel) {
        newCurrentLevelXP -= xpToNextLevel;
        newLevel++;
        xpToNextLevel = 100 + (newLevel * 50);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'totalXP': newTotalXP,
        'currentLevelXP': newCurrentLevelXP,
        'level': newLevel,
        'xpToNextLevel': xpToNextLevel,
      });
      print('🔍 About to check achievements from dashboard');
try {
  final firestoreService = FirestoreService();
  final newAchievements = await firestoreService.checkAndUnlockAchievements(user.uid);
  print('✅ Checked achievements. Found ${newAchievements.length} new ones');
} catch (e) {
  print('❌ ERROR checking achievements: $e');
}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
  content: Text('✅ ${habitData['name']} completed! +$xpValue XP'),
  backgroundColor: const Color(0xFF10B981),
  duration: const Duration(seconds: 2),
  behavior: SnackBarBehavior.floating,
  margin: EdgeInsets.only(
    bottom: MediaQuery.of(context).size.height * 0.05,
    left: 16,
    right: 16,
  ),
),
        );
      }
    } catch (e) {
      print('Error completing habit: $e');
    }
  }

  Stream<DocumentSnapshot> _getTodayProgressStream(String habitId) {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    return FirebaseFirestore.instance
        .collection('habits')
        .doc(habitId)
        .collection('progress')
        .doc(dateKey)
        .snapshots();
  }
}

class AnimatedLinesPainter extends CustomPainter {
  final double animationValue;

  AnimatedLinesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      final offset = (animationValue * size.height) % size.height;
      final yPosition = offset + (i * size.height / 5);

      final path = Path();
      for (double x = 0; x <= size.width; x += 20) {
        final y = yPosition + math.sin((x + animationValue * 200) / 50) * 30;
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    for (int i = -2; i < 3; i++) {
      final startX = (animationValue * 300) % size.width + (i * 100);
      final startY = -50 + (animationValue * 150) % size.height;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(startX + size.height * 1.2, startY + size.height * 1.2),
        paint,
      );
    }

    for (int i = 0; i < 3; i++) {
      final centerX = (animationValue * 200 + i * size.width / 3) % size.width;
      final centerY = (animationValue * 150 + i * size.height / 3) % size.height;
      final radius = 40 + math.sin(animationValue * 3) * 20;

      canvas.drawCircle(
        Offset(centerX, centerY),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
