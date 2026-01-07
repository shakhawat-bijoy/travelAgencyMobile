import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import '../models/booking.dart';
import 'hotel_booking_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _userData;
  bool _isUploading = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final data = await _firestoreService.getUserData(user.uid);
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching user data: $e');
    }
  }

  // Get user profile from Firebase Auth or use defaults
  Map<String, dynamic> get userProfile {
    final user = FirebaseAuth.instance.currentUser;
    return {
      'name': user?.displayName ?? 'Traveler',
      'email': user?.email ?? 'No email',
      'phone': user?.phoneNumber ?? '+1 (555) 123-4567',
      'location': 'New York, USA', // Location is not stored in Auth, keep mock or fetch from Firestore if implemented
      'photoURL': user?.photoURL,
    };
  }

  Future<void> _pickAndUploadImage({bool isCover = false}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: isCover ? 1024 : 512,
        maxHeight: isCover ? 512 : 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'user not logged in';

      final bytes = await image.readAsBytes();
      // Robust extension detection
      String extension = 'jpg';
      if (image.name.contains('.')) {
        extension = image.name.split('.').last.toLowerCase();
      } else if (image.mimeType != null) {
        extension = image.mimeType!.split('/').last;
      }

      if (kDebugMode) print('Starting upload for ${isCover ? 'cover' : 'profile'} photo: ${image.name} ($extension)');

      String downloadUrl;
      try {
        if (isCover) {
          downloadUrl = await _storageService.uploadCoverImage(
            user.uid,
            bytes,
            extension,
          );

          // Optimistic UI update
          if (mounted) {
            setState(() {
              _userData = UserModel(
                uid: _userData?.uid ?? user.uid,
                email: _userData?.email ?? user.email ?? '',
                displayName: _userData?.displayName ?? user.displayName ?? '',
                profilePhoto: _userData?.profilePhoto ?? '',
                coverPhoto: downloadUrl,
                bio: _userData?.bio ?? '',
                role: _userData?.role ?? 'user',
                savedTrips: _userData?.savedTrips ?? [],
              );
            });
          }

          // Parallel updates
          await Future.wait([
            _firestoreService.updateUserProfile(user.uid, {'coverPhoto': downloadUrl}).catchError((e) {
              if (kDebugMode) print('Non-fatal error updating cover photo in Firestore: $e');
              return null;
            }),
          ]);
        } else {
          downloadUrl = await _storageService.uploadProfileImage(
            user.uid,
            bytes,
            extension,
          );

          // Optimistic UI update
          if (mounted) {
            setState(() {
              _userData = UserModel(
                uid: _userData?.uid ?? user.uid,
                email: _userData?.email ?? user.email ?? '',
                displayName: _userData?.displayName ?? user.displayName ?? '',
                profilePhoto: downloadUrl,
                coverPhoto: _userData?.coverPhoto ?? '',
                bio: _userData?.bio ?? '',
                role: _userData?.role ?? 'user',
                savedTrips: _userData?.savedTrips ?? [],
              );
            });
          }

          // Parallel updates
          await Future.wait([
            user.updatePhotoURL(downloadUrl).then((_) => user.reload()).catchError((e) {
              if (kDebugMode) print('Non-fatal error updating Auth photoURL: $e');
              return null;
            }),
            _firestoreService.updateUserProfile(user.uid, {'profilePhoto': downloadUrl}).catchError((e) {
              if (kDebugMode) print('Non-fatal error updating profile photo in Firestore: $e');
              return null;
            }),
          ]);
        }
      } catch (e) {
        if (kDebugMode) print('FIREBASE STORAGE UPLOAD ERROR: $e');
        rethrow;
      }

      // No need to await full refetch if we updated optimistically, 
      // but let's sync in background if needed.
      _fetchUserData(); 

      setState(() {
        _isUploading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isCover ? 'Cover photo updated!' : 'Profile picture updated!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Stream<List<Booking>> get userBookingsStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return _firestoreService.getUserBookings(user.uid);
    }
    return Stream.value([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 100,
              ),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 30),
                  _buildMenuItems(),
                  const SizedBox(height: 30),
                  _buildUpcomingBookings(),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final user = _userData;
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Photo
            Stack(
              children: [
                GestureDetector(
                  onTap: _isUploading ? null : () => _pickAndUploadImage(isCover: true),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2642),
                      borderRadius: BorderRadius.circular(16),
                      image: user?.coverPhoto.isNotEmpty == true
                          ? DecorationImage(
                              image: NetworkImage(user!.coverPhoto),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: user?.coverPhoto.isEmpty == true
                        ? Center(
                            child: Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.white.withOpacity(0.3),
                              size: 40,
                            ),
                          )
                        : null,
                  ),
                ),
                // Camera button for Cover Photo
                Positioned(
                  top: 12,
                  right: 12,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _isUploading ? null : () => _pickAndUploadImage(isCover: true),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Profile Photo
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0A1628),
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[100],
                        backgroundImage: user?.profilePhoto.isNotEmpty == true
                            ? NetworkImage(user!.profilePhoto)
                            : null,
                        child: user?.profilePhoto.isEmpty == true
                            ? Text(
                                (user?.displayName ?? 'T').isNotEmpty
                                    ? (user?.displayName ?? 'T')[0].toUpperCase()
                                    : 'T',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              )
                            : null,
                      ),
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _isUploading ? null : () => _pickAndUploadImage(isCover: false),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF0A1628),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          user?.displayName ?? 'Traveler',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? 'No email',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        if (user?.bio.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              user!.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(
              'New York, USA',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildStatCard('12', 'Trips', Icons.flight_takeoff),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('28', 'Places', Icons.place)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('2.4K', 'Points', Icons.star)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    final menuItems = [
      {'icon': Icons.edit, 'title': 'Edit Profile'},
      {'icon': Icons.bookmark, 'title': 'Saved Places'},
      {'icon': Icons.payment, 'title': 'Payment Methods'},
      {'icon': Icons.language, 'title': 'Language'},
      {'icon': Icons.notifications, 'title': 'Notifications'},
      {'icon': Icons.security, 'title': 'Privacy & Security'},
      {'icon': Icons.help_outline, 'title': 'Help Center'},
      {'icon': Icons.info_outline, 'title': 'About'},
      {'icon': Icons.logout, 'title': 'Log Out'},
    ];

    return Column(
      children: menuItems
          .map(
            (item) => _buildMenuItem(
              item['icon'] as IconData,
              item['title'] as String,
            ),
          )
          .toList(),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (title == 'Log Out') {
              _showLogoutDialog(context);
            } else if (title == 'Edit Profile') {
              _showEditProfileDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title feature coming soon!'),
                  backgroundColor: Colors.blue[600],
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2642),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.amber, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Bookings & Reservations',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<Booking>>(
          stream: userBookingsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildNoBookings();
            }
            return Column(
              children: snapshot.data!.map((booking) => _buildFirestoreBookingCard(booking)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoBookings() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 60,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Bookings Yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start exploring and book your next adventure!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFirestoreBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.hotel, color: Colors.amber),
        title: Text(
          booking.tripId,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${booking.travelDate.day}/${booking.travelDate.month}/${booking.travelDate.year} - \$${booking.totalPrice}',
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            booking.status,
            style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }



  void _showEditProfileDialog(BuildContext context) {
    if (_userData == null) return;
    final nameController = TextEditingController(text: _userData!.displayName);
    final bioController = TextEditingController(text: _userData!.bio);
    final roleController = TextEditingController(text: _userData!.role);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2642),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: roleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Role (e.g., Traveler, Explorer)',
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.amber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await _firestoreService.updateUserProfile(user.uid, {
                    'displayName': nameController.text,
                    'bio': bioController.text,
                    'role': roleController.text,
                  });
                  await user.updateDisplayName(nameController.text);
                  await user.reload();
                  await _fetchUserData();
                }
                if (context.mounted) Navigator.pop(context);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update profile: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A2642),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _authService.signOut();
                if (mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
