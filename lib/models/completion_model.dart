import 'package:cloud_firestore/cloud_firestore.dart';

class Completion {
  final String id;
  final String habitId;
  final String userId;
  final DateTime completedAt;
  final String date;
  final int xpEarned;
  final int streakOnCompletion;
  final String notes;
  final bool wasLate;

  Completion({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.completedAt,
    required this.date,
    required this.xpEarned,
    this.streakOnCompletion = 0,
    this.notes = '',
    this.wasLate = false,
  });

  factory Completion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Completion(
      id: doc.id,
      habitId: data['habitId'] ?? '',
      userId: data['userId'] ?? '',
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      date: data['date'] ?? '',
      xpEarned: data['xpEarned'] ?? 0,
      streakOnCompletion: data['streakOnCompletion'] ?? 0,
      notes: data['notes'] ?? '',
      wasLate: data['wasLate'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'userId': userId,
      'completedAt': Timestamp.fromDate(completedAt),
      'date': date,
      'xpEarned': xpEarned,
      'streakOnCompletion': streakOnCompletion,
      'notes': notes,
      'wasLate': wasLate,
    };
  }

  Completion copyWith({
    String? id,
    String? habitId,
    String? userId,
    DateTime? completedAt,
    String? date,
    int? xpEarned,
    int? streakOnCompletion,
    String? notes,
    bool? wasLate,
  }) {
    return Completion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      completedAt: completedAt ?? this.completedAt,
      date: date ?? this.date,
      xpEarned: xpEarned ?? this.xpEarned,
      streakOnCompletion: streakOnCompletion ?? this.streakOnCompletion,
      notes: notes ?? this.notes,
      wasLate: wasLate ?? this.wasLate,
    );
  }

  bool get isToday {
    final today = DateTime.now();
    return completedAt.year == today.year &&
           completedAt.month == today.month &&
           completedAt.day == today.day;
  }

  String get timeAgo {
    final difference = DateTime.now().difference(completedAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}