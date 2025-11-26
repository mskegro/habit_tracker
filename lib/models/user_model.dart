import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLogin;
  final int totalXP;
  final int level;
  final int currentLevelXP;
  final int xpToNextLevel;
  final int longestStreak;
  final int currentTotalStreak;
  final int totalHabitsCompleted;
  final UserSettings settings;
  final List<String> achievements;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLogin,
    this.totalXP = 0,
    this.level = 1,
    this.currentLevelXP = 0,
    this.xpToNextLevel = 100,
    this.longestStreak = 0,
    this.currentTotalStreak = 0,
    this.totalHabitsCompleted = 0,
    required this.settings,
    this.achievements = const [],
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'User',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalXP: data['totalXP'] ?? 0,
      level: data['level'] ?? 1,
      currentLevelXP: data['currentLevelXP'] ?? 0,
      xpToNextLevel: data['xpToNextLevel'] ?? 100,
      longestStreak: data['longestStreak'] ?? 0,
      currentTotalStreak: data['currentTotalStreak'] ?? 0,
      totalHabitsCompleted: data['totalHabitsCompleted'] ?? 0,
      settings: UserSettings.fromMap(data['settings'] ?? {}),
      achievements: List<String>.from(data['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'totalXP': totalXP,
      'level': level,
      'currentLevelXP': currentLevelXP,
      'xpToNextLevel': xpToNextLevel,
      'longestStreak': longestStreak,
      'currentTotalStreak': currentTotalStreak,
      'totalHabitsCompleted': totalHabitsCompleted,
      'settings': settings.toMap(),
      'achievements': achievements,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLogin,
    int? totalXP,
    int? level,
    int? currentLevelXP,
    int? xpToNextLevel,
    int? longestStreak,
    int? currentTotalStreak,
    int? totalHabitsCompleted,
    UserSettings? settings,
    List<String>? achievements,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      currentLevelXP: currentLevelXP ?? this.currentLevelXP,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      longestStreak: longestStreak ?? this.longestStreak,
      currentTotalStreak: currentTotalStreak ?? this.currentTotalStreak,
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      settings: settings ?? this.settings,
      achievements: achievements ?? this.achievements,
    );
  }

  double get levelProgress {
    if (xpToNextLevel == 0) return 0;
    return (currentLevelXP / xpToNextLevel * 100).clamp(0.0, 100.0);
  }

  bool hasAchievement(String achievementId) {
    return achievements.contains(achievementId);
  }
}

class UserSettings {
  final bool darkMode;
  final bool notificationsEnabled;
  final String timeFormat;
  final bool dataShareConsent;

  UserSettings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.timeFormat = '12h',
    this.dataShareConsent = false,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      darkMode: map['darkMode'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      timeFormat: map['timeFormat'] ?? '12h',
      dataShareConsent: map['dataShareConsent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'notificationsEnabled': notificationsEnabled,
      'timeFormat': timeFormat,
      'dataShareConsent': dataShareConsent,
    };
  }

  UserSettings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? timeFormat,
    bool? dataShareConsent,
  }) {
    return UserSettings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      timeFormat: timeFormat ?? this.timeFormat,
      dataShareConsent: dataShareConsent ?? this.dataShareConsent,
    );
  }
}

