import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final int totalPoints;
  final int streakDays;
  final int ecoScore;
  final int level;
  final bool dailyReminders;
  final bool streakNotifications;
  final bool weeklyDigest;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.totalPoints = 0,
    this.streakDays = 0,
    this.ecoScore = 90,
    this.level = 1,
    this.dailyReminders = true,
    this.streakNotifications = true,
    this.weeklyDigest = true,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'totalPoints': totalPoints,
      'streakDays': streakDays,
      'ecoScore': ecoScore,
      'level': level,
      'dailyReminders': dailyReminders,
      'streakNotifications': streakNotifications,
      'weeklyDigest': weeklyDigest,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String uid) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
      return DateTime.now();
    }

    return UserProfile(
      uid: uid,
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Eco Champion',
      photoUrl: map['photoUrl'] as String?,
      totalPoints: (map['totalPoints'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      ecoScore: (map['ecoScore'] as num?)?.toInt() ?? 90,
      level: (map['level'] as num?)?.toInt() ?? 1,
      dailyReminders: map['dailyReminders'] as bool? ?? true,
      streakNotifications: map['streakNotifications'] as bool? ?? true,
      weeklyDigest: map['weeklyDigest'] as bool? ?? true,
      createdAt: parseDate(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? parseDate(map['updatedAt']) : null,
    );
  }

  factory UserProfile.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return UserProfile.fromMap(data, doc.id);
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoUrl,
    int? totalPoints,
    int? streakDays,
    int? ecoScore,
    int? level,
    bool? dailyReminders,
    bool? streakNotifications,
    bool? weeklyDigest,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      ecoScore: ecoScore ?? this.ecoScore,
      level: level ?? this.level,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      streakNotifications: streakNotifications ?? this.streakNotifications,
      weeklyDigest: weeklyDigest ?? this.weeklyDigest,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
