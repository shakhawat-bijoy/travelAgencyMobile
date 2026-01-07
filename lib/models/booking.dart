import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String tripId;
  final DateTime bookingDate;
  final DateTime travelDate;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final double totalPrice;
  final int peopleCount;

  Booking({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.bookingDate,
    required this.travelDate,
    this.status = 'pending',
    required this.totalPrice,
    this.peopleCount = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'travelDate': Timestamp.fromDate(travelDate),
      'status': status,
      'totalPrice': totalPrice,
      'peopleCount': peopleCount,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      id: id,
      userId: map['userId'] ?? '',
      tripId: map['tripId'] ?? '',
      bookingDate: (map['bookingDate'] as Timestamp).toDate(),
      travelDate: (map['travelDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'pending',
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      peopleCount: map['peopleCount'] ?? 1,
    );
  }
}
