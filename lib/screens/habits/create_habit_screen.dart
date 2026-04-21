import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({Key? key}) : super(key: key);

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  String _selectedCategory = 'popular';
  final user = FirebaseAuth.instance.currentUser;
  
final Map<String, List<Map<String, dynamic>>> _habitsByCategory = {
  'popular': [
    {'name': 'Walk', 'icon': '🚶', 'unit': 'steps', 'target': 10000, 'color': '#5B9BD5', 'trackingStyle': 'steps'},
    {'name': 'Sleep', 'icon': '🛏️', 'unit': 'hours', 'target': 8, 'color': '#9B59D5', 'trackingStyle': 'simple'},
    {'name': 'Drink water', 'icon': '💧', 'unit': 'ml', 'target': 3000, 'color': '#5DADE2', 'trackingStyle': 'water'},
    {'name': 'Prayer', 'icon': '🙏', 'unit': 'minutes', 'target': 10, 'color': '#27AE60', 'trackingStyle': 'timer'},
    {'name': 'Run', 'icon': '🏃', 'unit': 'km', 'target': 5, 'color': '#F39C12', 'trackingStyle': 'simple'},
    {'name': 'Stand', 'icon': '🧍', 'unit': 'hours', 'target': 8, 'color': '#F1C40F', 'trackingStyle': 'simple'},
    {'name': 'Cycling', 'icon': '🚴', 'unit': 'km', 'target': 10, 'color': '#3498DB', 'trackingStyle': 'simple'},
    {'name': 'Workout', 'icon': '💪', 'unit': 'minutes', 'target': 60, 'color': '#E74C3C', 'trackingStyle': 'timer'},
    {'name': 'Active Calorie', 'icon': '🔥', 'unit': 'kcal', 'target': 500, 'color': '#E67E22', 'trackingStyle': 'simple'},
    {'name': 'Gratitude', 'icon': '🕊️', 'unit': 'entries', 'target': 1, 'color': '#2E86C1', 'trackingStyle': 'simple'},
  ],

  'health': [
    {'name': 'Drink water', 'icon': '💧', 'unit': 'glasses', 'target': 8, 'color': '#5DADE2', 'trackingStyle': 'water'},
    {'name': 'Sleep', 'icon': '🛏️', 'unit': 'hours', 'target': 8, 'color': '#9B59D5', 'trackingStyle': 'simple'},
    {'name': 'Scripture Meditation', 'icon': '📖', 'unit': 'minutes', 'target': 10, 'color': '#27AE60', 'trackingStyle': 'timer'},
    {'name': 'Vitamins', 'icon': '💊', 'unit': 'times', 'target': 1, 'color': '#E74C3C', 'trackingStyle': 'simple'},
    {'name': 'Healthy Meal', 'icon': '🥗', 'unit': 'meals', 'target': 3, 'color': '#2ECC71', 'trackingStyle': 'simple'},
    {'name': 'Sunlight', 'icon': '☀️', 'unit': 'minutes', 'target': 15, 'color': '#F4D03F', 'trackingStyle': 'timer'},
    {'name': 'Steps', 'icon': '', 'unit': 'steps', 'target': 8000, 'color': '#1ABC9C', 'trackingStyle': 'steps'},
    {'name': 'Protein', 'icon': '🍗', 'unit': 'grams', 'target': 100, 'color': '#AF7AC5', 'trackingStyle': 'simple'},
    {'name': 'Veg Servings', 'icon': '🥦', 'unit': 'servings', 'target': 3, 'color': '#27AE60', 'trackingStyle': 'simple'},
    {'name': 'Fruit Servings', 'icon': '🍎', 'unit': 'servings', 'target': 2, 'color': '#C0392B', 'trackingStyle': 'simple'},
    {'name': 'Floss', 'icon': '🦷', 'unit': 'times', 'target': 1, 'color': '#5DADE2', 'trackingStyle': 'simple'},
    {'name': 'Posture Break', 'icon': '🪑', 'unit': 'times', 'target': 3, 'color': '#2E86C1', 'trackingStyle': 'simple'},
    {'name': 'Caffeine Cutoff', 'icon': '⛔', 'unit': 'hour', 'target': 14, 'color': '#C0392B', 'trackingStyle': 'simple'},
  ],

  'fitness': [
    {'name': 'Walk', 'icon': '🚶', 'unit': 'steps', 'target': 10000, 'color': '#5B9BD5', 'trackingStyle': 'steps'},
    {'name': 'Run', 'icon': '🏃', 'unit': 'minutes', 'target': 30, 'color': '#F39C12', 'trackingStyle': 'timer'},
    {'name': 'Cycling', 'icon': '🚴', 'unit': 'minutes', 'target': 30, 'color': '#3498DB', 'trackingStyle': 'timer'},
    {'name': 'Workout', 'icon': '💪', 'unit': 'minutes', 'target': 60, 'color': '#E74C3C', 'trackingStyle': 'timer'},
    {'name': 'Mobility', 'icon': '🤸', 'unit': 'minutes', 'target': 20, 'color': '#F59E0B', 'trackingStyle': 'timer'}, // replaces yoga
    {'name': 'Swimming', 'icon': '🏊', 'unit': 'minutes', 'target': 30, 'color': '#3498DB', 'trackingStyle': 'timer'},
    {'name': 'Stretch', 'icon': '🧍‍♂️', 'unit': 'minutes', 'target': 10, 'color': '#16A085', 'trackingStyle': 'timer'},
    {'name': 'Strength', 'icon': '🏋️', 'unit': 'sets', 'target': 12, 'color': '#C0392B', 'trackingStyle': 'simple'},
    {'name': 'Core', 'icon': '🧱', 'unit': 'minutes', 'target': 10, 'color': '#8E44AD', 'trackingStyle': 'timer'},
    {'name': 'HIIT', 'icon': '⚡', 'unit': 'minutes', 'target': 15, 'color': '#E67E22', 'trackingStyle': 'timer'},
    {'name': 'Tennis Drills', 'icon': '🎾', 'unit': 'minutes', 'target': 45, 'color': '#27AE60', 'trackingStyle': 'timer'},
    {'name': 'Prayer Walk', 'icon': '🚶‍♀️🙏', 'unit': 'minutes', 'target': 15, 'color': '#5B9BD5', 'trackingStyle': 'timer'},
  ],

  'home': [
    {'name': 'Clean Room', 'icon': '🧹', 'unit': 'times', 'target': 1, 'color': '#5DADE2', 'trackingStyle': 'simple'},
    {'name': 'Do Laundry', 'icon': '🧺', 'unit': 'times', 'target': 1, 'color': '#9B59D5', 'trackingStyle': 'simple'},
    {'name': 'Cook Meal', 'icon': '🍳', 'unit': 'meals', 'target': 2, 'color': '#F39C12', 'trackingStyle': 'simple'},
    {'name': 'Water Plants', 'icon': '🌱', 'unit': 'times', 'target': 1, 'color': '#2ECC71', 'trackingStyle': 'simple'},
    {'name': 'Dishes', 'icon': '🍽️', 'unit': 'times', 'target': 1, 'color': '#58D68D', 'trackingStyle': 'simple'},
    {'name': 'Tidy Desk', 'icon': '🗄️', 'unit': 'times', 'target': 1, 'color': '#2874A6', 'trackingStyle': 'simple'},
    {'name': 'Declutter', 'icon': '🧩', 'unit': 'items', 'target': 5, 'color': '#AF7AC5', 'trackingStyle': 'simple'},
    {'name': 'Vacuum', 'icon': '🧽', 'unit': 'rooms', 'target': 2, 'color': '#E67E22', 'trackingStyle': 'simple'},
    {'name': 'Make Bed', 'icon': '🛌', 'unit': 'times', 'target': 1, 'color': '#2E86C1', 'trackingStyle': 'simple'},
    {'name': 'Trash Out', 'icon': '🗑️', 'unit': 'times', 'target': 1, 'color': '#95A5A6', 'trackingStyle': 'simple'},
  ],

  'productivity': [
    {'name': 'Read Book', 'icon': '📚', 'unit': 'minutes', 'target': 30, 'color': '#3498DB', 'trackingStyle': 'timer'},
    {'name': 'Study', 'icon': '📖', 'unit': 'minutes', 'target': 120, 'color': '#9B59D5', 'trackingStyle': 'timer'},
    {'name': 'Code', 'icon': '💻', 'unit': 'minutes', 'target': 120, 'color': '#34495E', 'trackingStyle': 'timer'},
    {'name': 'Write Journal', 'icon': '📝', 'unit': 'pages', 'target': 2, 'color': '#F39C12', 'trackingStyle': 'simple'},
    {'name': 'Plan Day', 'icon': '🗓️', 'unit': 'times', 'target': 1, 'color': '#1ABC9C', 'trackingStyle': 'simple'},
    {'name': 'Deep Work', 'icon': '🎯', 'unit': 'minutes', 'target': 60, 'color': '#E74C3C', 'trackingStyle': 'timer'},
    {'name': 'Learn Language', 'icon': '🗣️', 'unit': 'minutes', 'target': 20, 'color': '#8E44AD', 'trackingStyle': 'timer'},
    {'name': 'Read Scripture', 'icon': '📜', 'unit': 'chapters', 'target': 1, 'color': '#7D3C98', 'trackingStyle': 'simple'},
  ],

  'nutrition': [
    {'name': 'Meal Prep', 'icon': '🥙', 'unit': 'meals', 'target': 2, 'color': '#27AE60', 'trackingStyle': 'simple'},
    {'name': 'Fiber', 'icon': '🌾', 'unit': 'grams', 'target': 25, 'color': '#D4AC0D', 'trackingStyle': 'simple'},
    {'name': 'Hydration', 'icon': '🚰', 'unit': 'ml', 'target': 2500, 'color': '#5DADE2', 'trackingStyle': 'water'},
    {'name': 'Slow Eating', 'icon': '🐢', 'unit': 'minutes', 'target': 15, 'color': '#AF7AC5', 'trackingStyle': 'timer'},
    {'name': 'Home Cooked', 'icon': '🍲', 'unit': 'meals', 'target': 2, 'color': '#E67E22', 'trackingStyle': 'simple'},
  ],

  'faith': [
    {'name': 'Bible Study', 'icon': '📖', 'unit': 'minutes', 'target': 20, 'color': '#2C3E50', 'trackingStyle': 'timer'},
    {'name': 'Prayer', 'icon': '🙏', 'unit': 'minutes', 'target': 10, 'color': '#27AE60', 'trackingStyle': 'timer'},
    {'name': 'Verse Memory', 'icon': '🧠', 'unit': 'verses', 'target': 1, 'color': '#8E44AD', 'trackingStyle': 'simple'},
    {'name': 'Devotional', 'icon': '🕯️', 'unit': 'minutes', 'target': 10, 'color': '#F4D03F', 'trackingStyle': 'timer'},
    {'name': 'Worship Music', 'icon': '🎵', 'unit': 'minutes', 'target': 15, 'color': '#2980B9', 'trackingStyle': 'timer'},
    {'name': 'Small Group', 'icon': '👥', 'unit': 'times', 'target': 1, 'color': '#16A085', 'trackingStyle': 'simple'},
    {'name': 'Serve/Volunteer', 'icon': '🤝', 'unit': 'times', 'target': 1, 'color': '#D35400', 'trackingStyle': 'simple'},
    {'name': 'Church Service', 'icon': '⛪', 'unit': 'times', 'target': 1, 'color': '#7F8C8D', 'trackingStyle': 'simple'},
    {'name': 'Prayer Walk', 'icon': '🚶‍♂️🙏', 'unit': 'minutes', 'target': 15, 'color': '#5B9BD5', 'trackingStyle': 'timer'},
    {'name': 'Encourage Someone', 'icon': '💌', 'unit': 'times', 'target': 1, 'color': '#E84393', 'trackingStyle': 'simple'},
  ],

  'quit': [
    {'name': 'No Junk Food', 'icon': '🥦', 'unit': 'day', 'target': 1, 'color': '#27AE60', 'trackingStyle': 'simple'},
    {'name': 'No Social Media', 'icon': '📱', 'unit': 'day', 'target': 1, 'color': '#C95D1F', 'trackingStyle': 'simple'},
    {'name': 'No Snooze Button', 'icon': '⏰', 'unit': 'day', 'target': 1, 'color': '#7D3C98', 'trackingStyle': 'simple'},
    {'name': 'No Late Nights', 'icon': '🌙', 'unit': 'day', 'target': 1, 'color': '#5D6D7E', 'trackingStyle': 'simple'},
    {'name': 'No Caffeine After 2PM', 'icon': '☕', 'unit': 'day', 'target': 1, 'color': '#6E2C00', 'trackingStyle': 'simple'},
    {'name': 'No Sugar Drinks', 'icon': '🥤', 'unit': 'day', 'target': 1, 'color': '#922B21', 'trackingStyle': 'simple'},
    {'name': 'No Late Snacking', 'icon': '🍪', 'unit': 'day', 'target': 1, 'color': '#B03A2E', 'trackingStyle': 'simple'},
    {'name': 'No Complaining', 'icon': '🙊', 'unit': 'day', 'target': 1, 'color': '#1ABC9C', 'trackingStyle': 'simple'},
    {'name': 'No Overthinking', 'icon': '🧩', 'unit': 'day', 'target': 1, 'color': '#117A65', 'trackingStyle': 'simple'},
    {'name': 'No Procrastination', 'icon': '🐌', 'unit': 'day', 'target': 1, 'color': '#2874A6', 'trackingStyle': 'simple'},
    {'name': 'No Unplanned Purchases', 'icon': '🛒', 'unit': 'day', 'target': 1, 'color': '#196F3D', 'trackingStyle': 'simple'},
    {'name': 'No TV Before Bed', 'icon': '📺', 'unit': 'day', 'target': 1, 'color': '#7B7D7D', 'trackingStyle': 'simple'},
    {'name': 'No Skipping Workouts', 'icon': '🏋️', 'unit': 'day', 'target': 1, 'color': '#C0392B', 'trackingStyle': 'simple'},
    {'name': 'No Energy Drinks', 'icon': '⚡', 'unit': 'day', 'target': 1, 'color': '#DC7633', 'trackingStyle': 'simple'},
    {'name': 'No Skipping Breakfast', 'icon': '🥣', 'unit': 'day', 'target': 1, 'color': '#73C6B6', 'trackingStyle': 'simple'},
  ],
};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Habit',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 156, 40, 156),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
              onPressed: () => setState(() => _selectedCategory = 'favorites'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  _getCategoryTitle(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getCategorySubtitle(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _selectedCategory == 'favorites'
                ? _buildFavoritesList()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _habitsByCategory[_selectedCategory]!.length,
                    itemBuilder: (context, index) {
                      final habit = _habitsByCategory[_selectedCategory]![index];
                      return _buildHabitItem(habit);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _showDetailedCustomHabitScreen(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 182, 89, 199),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Custom Habit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCategoryTab('🔥', 'popular'),
          _buildCategoryTab('☺️', 'health'),
          _buildCategoryTab('🏃', 'fitness'),
          _buildCategoryTab('🏠', 'home'),
          _buildCategoryTab('⏰', 'productivity'),
          _buildCategoryTab('💒', 'faith'),
          _buildCategoryTab('🚫', 'quit'),
          _buildCategoryTab('⭐', 'favorites'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String emoji, String category) {
    final isSelected = _selectedCategory == category;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 217, 172, 246) : const Color(0xFFF8FAFC),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: const Color.fromARGB(255, 154, 12, 161), width: 2) : null,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  String _getCategoryTitle() {
    const titles = {
      'popular': 'Popular',
      'health': 'Health',
      'fitness': 'Fitness',
      'home': 'Home',
      'productivity': 'Productivity',
      'faith': 'Faith',
      'quit': 'Quit Bad Habits',
      'favorites': 'My Favorites',
    };
    return titles[_selectedCategory] ?? 'Habits';
  }

  String _getCategorySubtitle() {
    const subtitles = {
      'popular': 'Most popular habits',
      'health': 'Take care of your health',
      'fitness': 'Stay active and fit',
      'home': 'Keep your space clean',
      'productivity': 'Boost your productivity',
      'faith': 'Strengthen your faith daily',
      'quit': 'Break bad habits',
      'favorites': 'Your saved habit templates',
    };
    return subtitles[_selectedCategory] ?? '';
  }

  Widget _buildHabitItem(Map<String, dynamic> habit) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user?.uid)
          .where('habitName', isEqualTo: habit['name'])
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        final isFavorited = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
        final docId = snapshot.hasData && snapshot.data!.docs.isNotEmpty 
            ? snapshot.data!.docs.first.id 
            : null;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(habit['icon'], style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  habit['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: const Color.fromARGB(255, 201, 116, 227),
                    ),
                    onPressed: () => _toggleFavorite(habit, isFavorited, docId),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Color.fromARGB(255, 200, 111, 239)),
                    onPressed: () => _showDetailedHabitScreen(habit),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFavoritesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('⭐', style: TextStyle(fontSize: 60)),
                SizedBox(height: 16),
                Text(
                  'No favorites yet!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tap 💜 on habits to save them here',
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final habit = {
              'name': doc['name'],
              'icon': doc['icon'],
              'unit': doc['unit'],
              'target': doc['target'],
              'color': doc['color'],
              'trackingStyle': doc['trackingStyle'] ?? 'simple',
            };
            return _buildHabitItem(habit);
          },
        );
      },
    );
  }

  Future<void> _toggleFavorite(Map<String, dynamic> habit, bool isFavorited, String? docId) async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login first')),
      );
      return;
    }

    try {
      if (isFavorited && docId != null) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(docId)
            .delete();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('💔 Removed from favorites'),
              backgroundColor: Color(0xFF64748B),
              duration: Duration(seconds: 1),
            ),
          );
        }
      } else {
        // Add to favorites
        await FirebaseFirestore.instance.collection('favorites').add({
          'userId': user!.uid,
          'habitName': habit['name'],
          'name': habit['name'],
          'icon': habit['icon'],
          'unit': habit['unit'],
          'target': habit['target'],
          'color': habit['color'],
          'trackingStyle': habit['trackingStyle'] ?? 'simple',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('💜 Added to favorites!'),
              backgroundColor: Color.fromARGB(255, 156, 36, 220),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDetailedHabitScreen(Map<String, dynamic> habitTemplate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailedHabitScreen(habitTemplate: habitTemplate),
      ),
    );
  }

  void _showDetailedCustomHabitScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailedHabitScreen(habitTemplate: null),
      ),
    );
  }
}

class DetailedHabitScreen extends StatefulWidget {
  final Map<String, dynamic>? habitTemplate;

  const DetailedHabitScreen({Key? key, this.habitTemplate}) : super(key: key);

  @override
  State<DetailedHabitScreen> createState() => _DetailedHabitScreenState();
}

class _DetailedHabitScreenState extends State<DetailedHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _targetController;
  late TextEditingController _unitController;
  late TextEditingController _iconController;
  late TextEditingController _xpController; 
  
  String _selectedIcon = '✓';
  Color _selectedColor = const Color(0xFF5B9BD5);
  String _habitType = 'Build';
  String _goalPeriod = 'Day-Long';
  String _timeRange = 'Anytime';
  String _trackingStyle = 'simple';
  bool _remindersEnabled = false;
  List<TimeOfDay> _reminderTimes = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habitTemplate?['name'] ?? '');
    _targetController = TextEditingController(text: (widget.habitTemplate?['target'] ?? 1).toString());
    _unitController = TextEditingController(text: widget.habitTemplate?['unit'] ?? 'times');
    _xpController = TextEditingController(text: '10');  
    _selectedIcon = widget.habitTemplate?['icon'] ?? '✓';
    _iconController = TextEditingController(text: _selectedIcon);
    _trackingStyle = widget.habitTemplate?['trackingStyle'] ?? 'simple';
    
    if (widget.habitTemplate?['color'] != null) {
      final colorHex = widget.habitTemplate!['color'] as String;
      _selectedColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    }
    
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    _iconController.dispose();
    _xpController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EAF6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(_selectedIcon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _nameController.text.isEmpty ? 'New Habit' : _nameController.text,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Habit Name and Icon
          _buildSection(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Enter Emoji'),
                        content: TextField(
                          controller: _iconController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 40),
                          decoration: const InputDecoration(
                            hintText: 'Tap to use keyboard',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() => _selectedIcon = value);
                            }
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_iconController.text.isNotEmpty) {
                                setState(() => _selectedIcon = _iconController.text);
                              }
                              Navigator.pop(context);
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(_selectedIcon, style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'Habit Name',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Description (Optional)',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tracking Style
          _buildSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tracking Style',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTrackingStyleChip('simple', 'Simple', '✓'),
                    _buildTrackingStyleChip('timer', 'Timer', '⏱️'),
                    _buildTrackingStyleChip('water', 'Water Glasses', '💧'),
                    _buildTrackingStyleChip('steps', 'Steps', '🚶'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Color
          _buildSection(
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Pick a color'),
                    content: SingleChildScrollView(
                      child: ColorPicker(
                        pickerColor: _selectedColor,
                        onColorChanged: (color) {
                          setState(() => _selectedColor = color);
                        },
                        pickerAreaHeightPercent: 0.8,
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Color',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 36,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Habit Type
          _buildSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Habit Type',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.help_outline, size: 20, color: Color(0xFF94A3B8)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton('Build', _habitType == 'Build'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTypeButton('Quit', _habitType == 'Quit'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Goal Value
          _buildSection(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Goal Value',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _unitController,
                        textAlign: TextAlign.left,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    const Text(
                      ' / Day',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _buildSection(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text(
                      'XP Value',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '⚡',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextField(
                        controller: _xpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'XP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Time Range
          _buildSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Time Range',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTimeButton('Anytime'),
                      _buildTimeButton('Morning'),
                      _buildTimeButton('Afternoon'),
                      _buildTimeButton('Evening'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Reminders
          _buildSection(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reminders',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _remindersEnabled,
                  onChanged: (value) => setState(() => _remindersEnabled = value),
                  activeColor: _selectedColor,
                ),
              ],
            ),
          ),

          if (_remindersEnabled) ...[
            const SizedBox(height: 12),
            _buildSection(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => _reminderTimes.add(time));
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ..._reminderTimes.map((time) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSection(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            time.format(context),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color(0xFFEF4444)),
                          onPressed: () => setState(() => _reminderTimes.remove(time)),
                        ),
                      ],
                    ),
                  ),
                )),
          ],

          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _saveHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Habit',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildTrackingStyleChip(String style, String label, String emoji) {
    final isSelected = _trackingStyle == style;
    return GestureDetector(
      onTap: () => setState(() => _trackingStyle = style),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _selectedColor : const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _habitType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _selectedColor : const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String time) {
    final isSelected = _timeRange == time;
    return GestureDetector(
      onTap: () => setState(() => _timeRange = time),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _selectedColor : const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login first')),
        );
        return;
      }

      final colorHex = '#${_selectedColor.value.toRadixString(16).substring(2).toUpperCase()}';
      
      final habitData = {
        'userId': user.uid,
        'name': _nameController.text,
        'icon': _selectedIcon,
        'unit': _unitController.text,
        'targetValue': double.tryParse(_targetController.text) ?? 1,
        'color': colorHex,
        'habitType': _habitType,
        'trackingStyle': _trackingStyle,
        'timeRange': _timeRange,
        'remindersEnabled': _remindersEnabled,
        'reminderTimes': _reminderTimes.map((t) => '${t.hour}:${t.minute}').toList(),
        'xpValue': int.tryParse(_xpController.text) ?? 10,
      };

      final habitId = widget.habitTemplate?['habitId'];
      
      if (habitId != null) {
        print('🔧 EDITING habit: $habitId');
        await FirebaseFirestore.instance
            .collection('habits')
            .doc(habitId)
            .update(habitData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${_nameController.text} habit updated!'),
              backgroundColor: const Color.fromARGB(255, 184, 226, 233),
            ),
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } else {
        print('✨ CREATING new habit');
        await FirebaseFirestore.instance.collection('habits').add({
          ...habitData,
          'currentStreak': 0,
          'longestStreak': 0,
          'totalCompletions': 0,
          'isActive': true,
          'isPaused': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${_nameController.text} habit created!'),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('❌ Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
