import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/trip_plan.dart';
import '../models/booking.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Operations ---

  Future<void> saveUserData(UserModel user) async {
    try {
      await _db.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      throw 'Error saving user data: $e';
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user data: $e';
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update(data);
    } catch (e) {
      throw 'Error updating profile: $e';
    }
  }

  // --- Trip Plan Operations ---

  Future<void> addTripPlan(TripPlan trip) async {
    try {
      await _db.collection('trip_plans').add(trip.toMap());
    } catch (e) {
      throw 'Error adding trip plan: $e';
    }
  }

  Stream<List<TripPlan>> getTripPlans() {
    return _db.collection('trip_plans').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TripPlan.fromFirestore(doc)).toList();
    });
  }

  // --- Booking Operations ---

  Future<void> createBooking(Booking booking) async {
    try {
      await _db.collection('bookings').add(booking.toMap());
    } catch (e) {
      throw 'Error creating booking: $e';
    }
  }

  Stream<List<Booking>> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
