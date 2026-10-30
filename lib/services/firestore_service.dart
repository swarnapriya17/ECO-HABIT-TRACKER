import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../models/check_in.dart';
import '../models/activity.dart';
import '../models/user_profile.dart';
import 'firebase_service.dart';

/// Handles user-scoped Cloud Firestore persistence.
///
/// Schema:
/// - users/{uid}
/// - users/{uid}/habits/{habitId}
/// - users/{uid}/checkIns/{checkInId} (ID: "${habitId}_${date}")
/// - users/{uid}/activities/{activityId}
class FirestoreService {
  FirebaseFirestore? get _db {
    if (!FirebaseService.isConfigured) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  // Collection References
  DocumentReference<Map<String, dynamic>>? _userDoc(String uid) =>
      _db?.collection('users').doc(uid);

  CollectionReference<Map<String, dynamic>>? _habitsCol(String uid) =>
      _db?.collection('users').doc(uid).collection('habits');

  CollectionReference<Map<String, dynamic>>? _checkInsCol(String uid) =>
      _db?.collection('users').doc(uid).collection('checkIns');

  CollectionReference<Map<String, dynamic>>? _activitiesCol(String uid) =>
      _db?.collection('users').doc(uid).collection('activities');

  // ==========================================
  // USER PROFILE
  // ==========================================

  /// Streams user profile from `users/{uid}`.
  Stream<UserProfile?> streamUserProfile(String uid) {
    final docRef = _userDoc(uid);
    if (docRef == null) return Stream.value(null);

    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserProfile.fromFirestore(snapshot);
    });
  }

  /// Creates or updates the user document in `users/{uid}`.
  Future<void> saveUserProfile(UserProfile profile) async {
    final docRef = _userDoc(profile.uid);
    if (docRef == null) return;

    await docRef.set(profile.toMap(), SetOptions(merge: true));
  }

  /// Updates specific fields in user profile.
  Future<void> updateUserFields(String uid, Map<String, dynamic> data) async {
    final docRef = _userDoc(uid);
    if (docRef == null) return;

    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data, SetOptions(merge: true));
  }

  // ==========================================
  // HABITS CRUD
  // ==========================================

  /// Streams habits for a given user from `users/{uid}/habits`.
  Stream<List<Habit>> streamHabits(String uid) {
    final col = _habitsCol(uid);
    if (col == null) return Stream.value(<Habit>[]);

    return col.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
    });
  }

  /// Saves a habit in `users/{uid}/habits/{habitId}`.
  Future<void> addHabit(String uid, Habit habit) async {
    final col = _habitsCol(uid);
    if (col == null) return;

    final habitId = habit.id.isNotEmpty ? habit.id : col.doc().id;

    final habitData = habit.toMap();
    habitData['id'] = habitId;
    habitData['createdAt'] = FieldValue.serverTimestamp();
    habitData['updatedAt'] = FieldValue.serverTimestamp();

    await col.doc(habitId).set(habitData);

    // Log activity
    await logActivity(
      uid,
      EcoActivity(
        id: 'a_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Created new habit "${habit.title}"',
        points: 5,
        icon: habit.category.icon,
        color: habit.category.color,
        type: 'habit_created',
        habitId: habitId,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Updates an existing habit.
  Future<void> updateHabit(String uid, Habit habit) async {
    final col = _habitsCol(uid);
    if (col == null) return;

    final habitData = habit.toMap();
    habitData['updatedAt'] = FieldValue.serverTimestamp();

    await col.doc(habit.id).update(habitData);
  }

  /// Deletes a habit from `users/{uid}/habits/{habitId}`.
  Future<void> deleteHabit(
    String uid,
    String habitId, {
    String? habitTitle,
  }) async {
    final col = _habitsCol(uid);
    if (col == null) return;

    await col.doc(habitId).delete();

    // Log deletion activity
    await logActivity(
      uid,
      EcoActivity(
        id: 'a_${DateTime.now().millisecondsSinceEpoch}',
        title: habitTitle != null
            ? 'Removed habit "$habitTitle"'
            : 'Removed habit',
        points: 0,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xFFEF4444),
        type: 'habit_deleted',
        habitId: habitId,
        timestamp: DateTime.now(),
      ),
    );
  }

  // ==========================================
  // CHECK-INS (DAILY COMPLETIONS)
  // ==========================================

  /// Generates a stable, idempotent check-in document ID.
  static String checkInDocId(String habitId, String dateString) =>
      '${habitId}_$dateString';

  /// Streams check-ins completed today (`users/{uid}/checkIns` where date == dateString).
  Stream<List<CheckIn>> streamTodayCheckIns(String uid, String dateString) {
    final col = _checkInsCol(uid);
    if (col == null) return Stream.value(<CheckIn>[]);

    return col.where('date', isEqualTo: dateString).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CheckIn.fromFirestore(doc)).toList();
    });
  }

  /// Streams all check-ins for the last N days (for weekly progress calculations).
  Stream<List<CheckIn>> streamRecentCheckIns(String uid, String minDateString) {
    final col = _checkInsCol(uid);
    if (col == null) return Stream.value(<CheckIn>[]);

    return col
        .where('date', isGreaterThanOrEqualTo: minDateString)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CheckIn.fromFirestore(doc))
              .toList();
        });
  }

  /// Toggles a habit's completion state for a given date.
  /// If [markComplete] is true, writes a CheckIn and increments total points.
  /// If false, deletes the CheckIn and decrements total points.
  Future<void> toggleCheckIn({
    required String uid,
    required Habit habit,
    required String dateString,
    required bool markComplete,
  }) async {
    final checkInsCol = _checkInsCol(uid);
    final userDoc = _userDoc(uid);
    if (checkInsCol == null || userDoc == null) return;

    final docId = checkInDocId(habit.id, dateString);
    final checkInRef = checkInsCol.doc(docId);

    if (markComplete) {
      final checkIn = CheckIn(
        id: docId,
        habitId: habit.id,
        habitTitle: habit.title,
        category: habit.category,
        date: dateString,
        completedAt: DateTime.now(),
        points: habit.points,
        co2ImpactKg: habit.co2ImpactKg,
        waterImpactL: habit.waterImpactL,
        plasticImpactItems: habit.plasticImpactItems,
      );

      await checkInRef.set(checkIn.toMap());

      // Update user aggregate points
      await userDoc.set({
        'totalPoints': FieldValue.increment(habit.points),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Log activity
      await logActivity(
        uid,
        EcoActivity(
          id: 'a_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Completed ${habit.title}',
          points: habit.points,
          icon: habit.category.icon,
          color: habit.category.color,
          type: 'habit_completed',
          habitId: habit.id,
          timestamp: DateTime.now(),
        ),
      );
    } else {
      await checkInRef.delete();

      // Decrement user aggregate points safely
      await userDoc.set({
        'totalPoints': FieldValue.increment(-habit.points),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  // ==========================================
  // ACTIVITIES TIMELINE
  // ==========================================

  /// Streams recent activity history from `users/{uid}/activities`.
  Stream<List<EcoActivity>> streamActivities(String uid, {int limit = 30}) {
    final col = _activitiesCol(uid);
    if (col == null) return Stream.value(<EcoActivity>[]);

    return col
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EcoActivity.fromFirestore(doc))
              .toList();
        });
  }

  /// Appends an activity event into `users/{uid}/activities/{activityId}`.
  Future<void> logActivity(String uid, EcoActivity activity) async {
    final col = _activitiesCol(uid);
    if (col == null) return;

    final actId = activity.id.isNotEmpty ? activity.id : col.doc().id;

    final data = activity.toMap();
    data['id'] = actId;

    await col.doc(actId).set(data);
  }

  // ==========================================
  // SEED INITIAL SAMPLE HABITS FOR NEW USERS
  // ==========================================

  /// Checks if the user already has any habits saved in Firestore.
  Future<bool> userHasHabits(String uid) async {
    final col = _habitsCol(uid);
    if (col == null) return true;

    final snapshot = await col.limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  /// Seeds default curated eco habits ONLY if user has 0 habits.
  /// Prevents duplicating default habits on subsequent logins.
  Future<void> seedInitialHabitsIfEmpty(
    String uid,
    List<Habit> sampleHabits,
  ) async {
    final col = _habitsCol(uid);
    if (col == null) return;

    final hasHabits = await userHasHabits(uid);
    if (hasHabits) return; // User already has data, do not seed or overwrite

    final batch = _db!.batch();
    for (var habit in sampleHabits) {
      final docRef = col.doc(habit.id);
      final data = habit.toMap();
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      batch.set(docRef, data);
    }

    await batch.commit();

    // Log welcome activity
    await logActivity(
      uid,
      EcoActivity(
        id: 'a_welcome_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Joined Eco Habit Tracker! Welcome onboard 🌱',
        points: 50,
        icon: Icons.eco_rounded,
        color: const Color(0xFF16A34A),
        type: 'welcome',
        timestamp: DateTime.now(),
      ),
    );
  }
}
