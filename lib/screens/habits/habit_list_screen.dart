import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamified_habit_tracker/widgets/bottom_nav_bar.dart';
import 'dart:math' as math;

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({Key? key}) : super(key: key);

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
          ),
        ),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: AnimatedLinesPainter(_animationController.value),
                  size: Size.infinite,
                );
              },
            ),

            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Track my\nhabits!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user?.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final userData = snapshot.data!.data() as Map<String, dynamic>?;
                                    final totalXP = ((userData?['totalXP'] ?? 0) as num).toInt();
                                    final level = ((userData?['level'] ?? 1) as num).toInt();
                                    return Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                          ),
                                          child: Text(
                                            '⚡ $totalXP XP',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                          ),
                                          child: Text(
                                            '🎯 Level $level',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.white, size: 28),
                            onPressed: () {
                              Navigator.pushNamed(context, '/create-habit');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Habits List
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('habits')
                            .where('userId', isEqualTo: user?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF9333EA),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Error Loading Habits',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text('No data from Firestore'),
                            );
                          }

                          final habits = snapshot.data!.docs;

                          if (habits.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '📋',
                                      style: TextStyle(fontSize: 64),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'No habits yet',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Create your first habit to get started!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/create-habit');
                                      },
                                      icon: const Icon(Icons.add),
                                      label: const Text('Create Habit'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF9333EA),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final doc = habits[index];
                              final data = doc.data() as Map<String, dynamic>;
                              return _buildHabitCard(context, doc.id, data);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentRoute: '/habits'),
    );
  }

  Widget _buildHabitCard(BuildContext context, String habitId, Map<String, dynamic> data) {
    final color = data['color'] ?? '#06B6D4';
    final icon = data['icon'] ?? '✓';
    final name = data['name'] ?? 'Habit';
    final currentStreak = ((data['currentStreak'] ?? 0) as num).toInt();
    final xpValue = ((data['xpValue'] ?? 10) as num).toInt();
    final isPaused = data['isPaused'] ?? false;
    final targetValue = ((data['targetValue'] ?? 1) as num).toDouble();
    final unit = data['unit'] ?? 'times';
    final habitColor = Color(int.parse(color.replaceFirst('#', '0xFF')));

    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('habits')
          .doc(habitId)
          .collection('progress')
          .doc(today)
          .snapshots(),
      builder: (context, progressSnapshot) {
        double currentValue = 0;
        bool isCompleted = false;
          if (progressSnapshot.hasError) {
      return const SizedBox.shrink();  // Hide the card if error
    }

        if (progressSnapshot.hasData && progressSnapshot.data!.exists) {
          final progressData = progressSnapshot.data!.data() as Map<String, dynamic>?;
          if (progressData != null) {
            currentValue = ((progressData['value'] ?? 0) as num).toDouble();
            isCompleted = progressData['completed'] ?? false;
          }
        }

        final progressPercentage = (currentValue / targetValue).clamp(0.0, 1.0);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/habit-detail',
              arguments: {
                'habitId': habitId,
                'habitData': data,
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isPaused ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPaused ? const Color(0xFFE2E8F0) : habitColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: habitColor.withOpacity(isCompleted ? 0.15 : 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                if (!isPaused)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          width: MediaQuery.of(context).size.width * progressPercentage,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                habitColor.withOpacity(0.15),
                                habitColor.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              habitColor,
                              habitColor.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: habitColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              icon,
                              style: const TextStyle(fontSize: 32),
                            ),
                            if (isCompleted)
                              const Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isPaused
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),

                            if (!isPaused && !isCompleted)
                              Text(
                                '${currentValue.toInt()} / ${targetValue.toInt()} $unit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: habitColor,
                                ),
                              )
                            else if (isCompleted)
                              Text(
                                '✓ Completed today!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: habitColor,
                                ),
                              ),

                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: habitColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '🔥 $currentStreak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: habitColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBBF24).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '⚡ +$xpValue XP',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (isPaused)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Paused',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF92400E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (!isPaused)
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? habitColor
                                : habitColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: habitColor,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (!isCompleted)
                                SizedBox(
                                  width: 46,
                                  height: 46,
                                  child: CircularProgressIndicator(
                                    value: progressPercentage,
                                    strokeWidth: 3,
                                    backgroundColor: Colors.transparent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      habitColor,
                                    ),
                                  ),
                                ),
                              Icon(
                                Icons.check,
                                color: isCompleted
                                    ? Colors.white
                                    : habitColor,
                                size: 28,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2.5
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

    // Draw diagonal lines
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