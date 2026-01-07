class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String profilePhoto;
  final String coverPhoto;
  final String bio;
  final String role;
  final List<String> savedTrips;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.profilePhoto = '',
    this.coverPhoto = '',
    this.bio = '',
    this.role = 'user',
    this.savedTrips = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
      'bio': bio,
      'role': role,
      'savedTrips': savedTrips,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      profilePhoto: map['profilePhoto'] ?? '',
      coverPhoto: map['coverPhoto'] ?? '',
      bio: map['bio'] ?? '',
      role: map['role'] ?? 'user',
      savedTrips: List<String>.from(map['savedTrips'] ?? []),
    );
  }
}
