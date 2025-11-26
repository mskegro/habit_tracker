import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String icon;
  final String color;
  final String category;
  final HabitFrequency frequency;
  final int xpValue;
  final int currentStreak;
  final int longestStreak;
  final int totalCompletions;
  final String? reminderTime;
  final bool reminderEnabled;
  final bool isActive;
  final bool isPaused;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;
  final DateTime updatedAt;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    this.icon = '✓',
    this.color = '#06B6D4',
    this.category = 'other',
    required this.frequency,
    this.xpValue = 10,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletions = 0,
    this.reminderTime,
    this.reminderEnabled = false,
    this.isActive = true,
    this.isPaused = false,
    required this.createdAt,
    this.lastCompletedAt,
    required this.updatedAt,
  });

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Habit(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Unnamed Habit',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '✓',
      color: data['color'] ?? '#06B6D4',
      category: data['category'] ?? 'other',
      frequency: HabitFrequency.fromMap(data['frequency'] ?? {}),
      xpValue: data['xpValue'] ?? 10,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      totalCompletions: data['totalCompletions'] ?? 0,
      reminderTime: data['reminderTime'],
      reminderEnabled: data['reminderEnabled'] ?? false,
      isActive: data['isActive'] ?? true,
      isPaused: data['isPaused'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastCompletedAt: (data['lastCompletedAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'icon': icon,
      'color': color,
      'category': category,
      'frequency': frequency.toMap(),
      'xpValue': xpValue,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompletions': totalCompletions,
      'reminderTime': reminderTime,
      'reminderEnabled': reminderEnabled,
      'isActive': isActive,
      'isPaused': isPaused,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastCompletedAt': lastCompletedAt != null ? Timestamp.fromDate(lastCompletedAt!) : null,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Habit copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? icon,
    String? color,
    String? category,
    HabitFrequency? frequency,
    int? xpValue,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
    String? reminderTime,
    bool? reminderEnabled,
    bool? isActive,
    bool? isPaused,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      xpValue: xpValue ?? this.xpValue,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      isActive: isActive ?? this.isActive,
      isPaused: isPaused ?? this.isPaused,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isCompletedToday {
    if (lastCompletedAt == null) return false;
    final today = DateTime.now();
    return lastCompletedAt!.year == today.year &&
           lastCompletedAt!.month == today.month &&
           lastCompletedAt!.day == today.day;
  }
}

class HabitFrequency {
  final String type;
  final List<String> daysOfWeek;
  final int timesPerWeek;

  HabitFrequency({
    required this.type,
    this.daysOfWeek = const [],
    this.timesPerWeek = 7,
  });

  factory HabitFrequency.fromMap(Map<String, dynamic> map) {
    return HabitFrequency(
      type: map['type'] ?? 'daily',
      daysOfWeek: List<String>.from(map['daysOfWeek'] ?? []),
      timesPerWeek: map['timesPerWeek'] ?? 7,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'daysOfWeek': daysOfWeek,
      'timesPerWeek': timesPerWeek,
    };
  }

  bool shouldBeCompletedToday() {
    if (type == 'daily') return true;
    
    if (type == 'weekly') {
      final today = DateTime.now();
      final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][today.weekday - 1];
      return daysOfWeek.contains(dayName);
    }
    
    return true;
  }
}
