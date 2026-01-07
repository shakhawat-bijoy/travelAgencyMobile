import 'package:cloud_firestore/cloud_firestore.dart';

class TripPlan {
  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final String imageUrl;
  final String destination;
  final List<String> itinerary;
  final List<String> categories;
  final double rating;
  final int reviewsCount;

  TripPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.imageUrl,
    required this.destination,
    this.itinerary = const [],
    this.categories = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'imageUrl': imageUrl,
      'destination': destination,
      'itinerary': itinerary,
      'categories': categories,
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }

  factory TripPlan.fromMap(Map<String, dynamic> map) {
    return TripPlan(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      duration: map['duration'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      destination: map['destination'] ?? '',
      itinerary: List<String>.from(map['itinerary'] ?? []),
      categories: List<String>.from(map['categories'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewsCount: map['reviewsCount'] ?? 0,
    );
  }

  factory TripPlan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TripPlan.fromMap({...data, 'id': doc.id});
  }
}
