import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamified_habit_tracker/widgets/purple_background.dart';
import 'package:gamified_habit_tracker/screens/habits/create_habit_screen.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';
import 'package:gamified_habit_tracker/services/confetti_service.dart';

class HabitDetailScreen extends StatefulWidget {
  final String habitId;
  final Map<String, dynamic> habitData;

  const HabitDetailScreen({
    Key? key,
    required this.habitId,
    required this.habitData,
  }) : super(key: key);

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> with TickerProviderStateMixin {
  late String trackingStyle;
  late Color habitColor;
  double currentValue = 0;
  double targetValue = 0;
  
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;

  late AnimationController _progressController;
  late AnimationController _pulseController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    trackingStyle = widget.habitData['trackingStyle'] ?? 'simple';
    targetValue = ((widget.habitData['targetValue'] as num?) ?? 1).toDouble();
    
    final colorHex = widget.habitData['color'] ?? '#5B9BD5';
    habitColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    
    _loadTodayProgress();
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    if (trackingStyle == 'timer') {
      _seconds = (targetValue * 60).toInt();
    }
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));

  }
Widget _buildConfetti() {
  return Align(
    alignment: Alignment.topCenter,
    child: ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      particleDrag: 0.05,
      emissionFrequency: 0.05,
      numberOfParticles: 80,
      gravity: 0.1,
      shouldLoop: false,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple,
        Colors.yellow,
        Colors.red,
      ],
    ),
  );
}
  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    _pulseController.dispose();
    _confettiController.dispose(); 
    super.dispose();
  }

  Future<void> _loadTodayProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final progressDoc = await FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .collection('progress')
          .doc(dateKey)
          .get();

      if (progressDoc.exists) {
        final data = progressDoc.data();
        setState(() {
          currentValue = ((data?['value'] as num?) ?? 0).toDouble();
          if (trackingStyle == 'timer') {
            final remainingSeconds = ((data?['remainingSeconds'] as num?) ?? _seconds).toInt();
            _seconds = remainingSeconds;
          }
        });
        _progressController.animateTo(
          (currentValue / targetValue).clamp(0.0, 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
        );
      }
    } catch (e) {
      print('Error loading progress: $e');
    }
  }

      Future<void> _saveProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    try {
      final progressRef = FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .collection('progress')
          .doc(dateKey);

      final existingProgress = await progressRef.get();
      final wasAlreadyCompleted = existingProgress.exists && 
          (existingProgress.data()?['completed'] as bool? ?? false);

      final data = {
        'value': currentValue,
        'targetValue': targetValue,
        'date': dateKey,
        'timestamp': FieldValue.serverTimestamp(),
        'completed': currentValue >= targetValue,
      };

      if (trackingStyle == 'timer') {
        data['remainingSeconds'] = _seconds;
      }

      await progressRef.set(data, SetOptions(merge: true));

      if (currentValue >= targetValue && !wasAlreadyCompleted) {
        final xpValue = ((widget.habitData['xpValue'] ?? 10) as num).toInt();
        
        await FirebaseFirestore.instance.collection('completions').add({
          'userId': user.uid,
          'habitId': widget.habitId,
          'habitName': widget.habitData['name'] ?? 'Habit',
          'xpEarned': xpValue,
          'date': dateKey,
          'completedAt': FieldValue.serverTimestamp(),
          'streakOnCompletion': ((widget.habitData['currentStreak'] ?? 0) as num).toInt() + 1,
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

        await _updateStreak();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newLevel > currentLevel 
                  ? '🎉 LEVEL UP! +$xpValue XP → Level $newLevel'
                  : '✅ +$xpValue XP gained!'
              ),
              backgroundColor: newLevel > currentLevel ? Colors.purple : const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error saving progress: $e');
    }
  }
  Future<void> _updateStreak() async {
    final habitRef = FirebaseFirestore.instance.collection('habits').doc(widget.habitId);
    
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final habitDoc = await transaction.get(habitRef);
        
        if (habitDoc.exists) {
          final data = habitDoc.data();
          
          int currentStreak = 0;
          int longestStreak = 0;
          int totalCompletions = 0;
          
          if (data != null) {
            currentStreak = (data['currentStreak'] is int) 
                ? data['currentStreak'] as int
                : (data['currentStreak'] as num?)?.toInt() ?? 0;
            
            longestStreak = (data['longestStreak'] is int)
                ? data['longestStreak'] as int
                : (data['longestStreak'] as num?)?.toInt() ?? 0;
            
            totalCompletions = (data['totalCompletions'] is int)
                ? data['totalCompletions'] as int
                : (data['totalCompletions'] as num?)?.toInt() ?? 0;
          }
          
          final int newStreak = currentStreak + 1;
          final int newLongest = newStreak > longestStreak ? newStreak : longestStreak;
          
          transaction.update(habitRef, {
            'currentStreak': newStreak,
            'longestStreak': newLongest,
            'totalCompletions': totalCompletions + 1,
          });
        }
      });
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  void _startTimer() {
    if (_isRunning) return;
    
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
        _saveProgress();
      } else {
        _stopTimer();
        _onTimerComplete();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
    _saveProgress();
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = (targetValue * 60).toInt();
      currentValue = 0;
    });
    _saveProgress();
  }

  void _onTimerComplete() {
    setState(() => currentValue = targetValue);
    _saveProgress();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Completed!'),
        content: Text('Great job completing ${widget.habitData['name']}!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: habitColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  void _incrementValue(double amount) {
  setState(() {
    currentValue = (currentValue + amount).clamp(0, targetValue * 2);
  });
  _progressController.animateTo(
    (currentValue / targetValue).clamp(0.0, 1.0),
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutCubic,
  );
  _saveProgress();
  
  if (currentValue >= targetValue) {
    _confettiController.play();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 ${widget.habitData['name']} completed! Goal reached!'),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
  void _decrementValue(double amount) {
    setState(() {
      currentValue = (currentValue - amount).clamp(0, targetValue * 2);
    });
    _progressController.animateTo(
      (currentValue / targetValue).clamp(0.0, 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    _saveProgress();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(),
    body: Stack( 
      children: [
        PurpleBackground(
          child: SafeArea(
            child: _buildBody(),
          ),
        ),
        _buildConfetti(), 
      ],
    ),
  );
}
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.deepPurple.shade700,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Text(
            widget.habitData['icon'] ?? '✓',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.habitData['name'] ?? 'Habit',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite, color: Color(0xFFFF6B9D)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: _buildContent(),
            ),
            _buildBottomTabs(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (trackingStyle) {
      case 'timer':
        return _buildTimerContent();
      case 'water':
        return _buildWaterContent();
      case 'steps':
        return _buildStepsContent();
      default:
        return _buildSimpleContent();
    }
  }

  Widget _buildTimerContent() {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    
    return Column(
      children: [
        const SizedBox(height: 40),
        
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
              
              SizedBox(
                width: 280,
                height: 280,
                child: CircularProgressIndicator(
                  value: 1 - (_seconds / (targetValue * 60)),
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(habitColor),
                ),
              ),
              
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 60),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
                iconSize: 28,
                onPressed: _resetTimer,
              ),
            ),
            
            const SizedBox(width: 40),
            
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: habitColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: habitColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  _isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                iconSize: 40,
                onPressed: _isRunning ? _stopTimer : _startTimer,
              ),
            ),
            
            const SizedBox(width: 40),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF64748B)),
                iconSize: 28,
                onPressed: () {
                  setState(() => _seconds += 60);
                  _saveProgress();
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildWaterContent() {
  final glassCapacity = 250.0; 
  
  return Column(
    children: [
      const SizedBox(height: 20),
      
      Column(
        children: [
          Text(
            '${currentValue.toInt()} ${widget.habitData['unit'] ?? 'ml'}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            '/${targetValue.toInt()} ${widget.habitData['unit'] ?? 'ml'}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 40),
      
      AnimatedBuilder(
        animation: _progressController,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(200, 300),
            painter: FlowerPainter(
              fillLevel: currentValue / targetValue,
              color: habitColor,
            ),
          );
        },
      ),
      
      const SizedBox(height: 40),
      
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.remove, color: Color(0xFF64748B)),
              iconSize: 28,
              onPressed: () => _decrementValue(glassCapacity),
            ),
          ),
          
          const SizedBox(width: 20),
          
          GestureDetector(
            onTap: () => _incrementValue(glassCapacity),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: habitColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: habitColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          
          const SizedBox(width: 20),
          
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
              iconSize: 28,
              onPressed: () {
                setState(() {
                  currentValue = 0;
                });
                _progressController.animateTo(0);
                _saveProgress();
              },
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 60),
    ],
  );
}

  Widget _buildStepsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          Column(
            children: [
              Text(
                widget.habitData['icon'] ?? '🚶',
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              Text(
                currentValue.toInt().toString(),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '/${targetValue.toInt()} ${widget.habitData['unit'] ?? 'steps'}',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 300,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (currentValue / targetValue).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 60),
          
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIncrementButton('+100', 100),
                  const SizedBox(width: 16),
                  _buildIncrementButton('+500', 500),
                  const SizedBox(width: 16),
                  _buildIncrementButton('+1000', 1000),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: TextButton(
                      onPressed: () => _decrementValue(100),
                      child: Text(
                        '-100',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: habitColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 100,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() => currentValue = 0);
                        _progressController.animateTo(0);
                        _saveProgress();
                      },
                      icon: Icon(Icons.refresh, color: habitColor),
                      label: Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: habitColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 60),
          
          _buildBottomTabs(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIncrementButton(String label, double amount) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => _incrementValue(amount),
        child: Text(
          label,
          style: TextStyle(
            color: habitColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleContent() {
    return Column(
      children: [
        const SizedBox(height: 60),
        
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentValue.toInt().toString(),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                '/ ${targetValue.toInt()} ${widget.habitData['unit'] ?? 'times'}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 60),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.remove, color: habitColor),
                iconSize: 28,
                onPressed: () => _decrementValue(1),
              ),
            ),
            
            const SizedBox(width: 40),
            
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: habitColor),
                iconSize: 40,
                onPressed: () => _incrementValue(1),
              ),
            ),
            
            const SizedBox(width: 40),
            
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.check, color: habitColor),
                iconSize: 28,
                onPressed: () {
                  setState(() => currentValue = targetValue);
                  _progressController.animateTo(1.0);
                  _saveProgress();
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildStepsContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        
        Column(
          children: [
            Text(
              widget.habitData['icon'] ?? '🚶',
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 20),
            Text(
              currentValue.toInt().toString(),
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '/${targetValue.toInt()} ${widget.habitData['unit'] ?? 'steps'}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 300,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (currentValue / targetValue).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 60),
        
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIncrementButton('+100', 100),
                const SizedBox(width: 16),
                _buildIncrementButton('+500', 500),
                const SizedBox(width: 16),
                _buildIncrementButton('+1000', 1000),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: TextButton(
                    onPressed: () => _decrementValue(100),
                    child: Text(
                      '-100',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: habitColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 100,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() => currentValue = 0);
                      _progressController.animateTo(0);
                      _saveProgress();
                    },
                    icon: Icon(Icons.refresh, color: habitColor),
                    label: Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: habitColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildBottomTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit Habit',
                  color: const Color(0xFF06B6D4),
                  onTap: _editHabit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.delete,
                  label: 'Delete',
                  color: const Color(0xFFEF4444),
                  onTap: _deleteHabit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Complete',
                  color: const Color(0xFF10B981),
                  onTap: _completeHabit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.pause_circle,
                  label: 'Pause',
                  color: const Color(0xFFF59E0B),
                  onTap: _pauseHabit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedHabitScreen(
          habitTemplate: {
            'name': widget.habitData['name'],
            'icon': widget.habitData['icon'],
            'unit': widget.habitData['unit'],
            'target': widget.habitData['targetValue'],
            'color': widget.habitData['color'],
            'trackingStyle': widget.habitData['trackingStyle'],
            'habitType': widget.habitData['habitType'] ?? 'Build',
            'timeRange': widget.habitData['timeRange'] ?? 'Anytime',
            'remindersEnabled': widget.habitData['remindersEnabled'] ?? false,
            'habitId': widget.habitId, 
          },
        ),
      ),
    ).then((_) {
      _loadTodayProgress();
    });
  }

void _completeHabit() {
  setState(() => currentValue = targetValue);
  _progressController.animateTo(1.0);
  _confettiController.play(); 
  _saveProgress();
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('✅ ${widget.habitData['name']} completed!'),
      backgroundColor: const Color(0xFF10B981),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
  Future<void> _pauseHabit() async {
    try {
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .update({'isPaused': true});
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit paused'),
            backgroundColor: Color(0xFFF59E0B),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error pausing habit: $e');
    }
  }

  Future<void> _deleteHabit() async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Habit?'),
      content: const Text('This action cannot be undone. All progress will be lost.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFEF4444),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    try {
      // Delete the habit
      await FirebaseFirestore.instance
          .collection('habits')
          .doc(widget.habitId)
          .delete();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit deleted'),
            backgroundColor: Color(0xFFEF4444),
            duration: Duration(seconds: 1),
          ),
        );
        // Wait then navigate
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      print('Error deleting habit: $e');
    }
  }
}
}

class FlowerPainter extends CustomPainter {
  final double fillLevel;
  final Color color;

  FlowerPainter({required this.fillLevel, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillProgress = fillLevel.clamp(0.0, 1.0);
    
    if (fillProgress > 0) {
      final stemPaint = Paint()
        ..color = Colors.green[700]!
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      
      final stemHeight = size.height * 0.6 * fillProgress;
      canvas.drawLine(
        Offset(size.width / 2, size.height),
        Offset(size.width / 2, size.height - stemHeight),
        stemPaint,
      );
      
      if (fillProgress > 0.3) {
        final leafPaint = Paint()
          ..color = Colors.green[600]!
          ..style = PaintingStyle.fill;
        
        final leafSize = 15.0 * fillProgress;
        final leafY = size.height - (stemHeight * 0.5);
        
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(size.width / 2 - 20, leafY),
            width: leafSize * 2,
            height: leafSize,
          ),
          leafPaint,
        );
        
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(size.width / 2 + 20, leafY),
            width: leafSize * 2,
            height: leafSize,
          ),
          leafPaint,
        );
      }
    }

    if (fillProgress > 0.2) {
      final centerX = size.width / 2;
      final centerY = size.height - (size.height * 0.6 * fillProgress);
      final bloomProgress = ((fillProgress - 0.2) / 0.8).clamp(0.0, 1.0);
      final flowerSize = 25 + (bloomProgress * 45);
      
      final paint = Paint()
        ..style = PaintingStyle.fill;

      final petalCount = (3 + (bloomProgress * 5)).toInt().clamp(3, 8);
      for (int i = 0; i < petalCount; i++) {
        final angle = (i / petalCount) * 2 * math.pi;
        final petalDistance = flowerSize * 0.65;
        final petalX = centerX + petalDistance * math.cos(angle);
        final petalY = centerY + petalDistance * math.sin(angle);
        
        paint.color = color.withOpacity(0.6 + (bloomProgress * 0.3));
        
        canvas.drawCircle(
          Offset(petalX, petalY),
          flowerSize * 0.35,
          paint,
        );
      }

      paint.color = Colors.yellow[700]!.withOpacity(0.8 + (bloomProgress * 0.2));
      canvas.drawCircle(
        Offset(centerX, centerY),
        flowerSize * 0.25,
        paint,
      );
      
      paint.color = Colors.orange[800]!.withOpacity(0.6);
      canvas.drawCircle(
        Offset(centerX, centerY),
        flowerSize * 0.12,
        paint,
      );
    } else if (fillProgress > 0) {
      final centerX = size.width / 2;
      final centerY = size.height - (size.height * 0.6 * fillProgress);
      final budSize = 10 + (fillProgress * 20);
      
      final paint = Paint()
        ..color = Colors.green[300]!
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(centerX, centerY),
        budSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FlowerPainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel || oldDelegate.color != color;
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}