import 'package:firebase_auth/firebase_auth.dart' as import_firebase_auth;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'tourist_spots.dart';
import 'saved_screen.dart';
import 'add_trip_screen.dart';
import 'notifications_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';
import 'hotel_detail_screen.dart';
import 'resort_details_screen.dart';
import 'hotels_list_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _selectedTab = 1; // 0: Popular, 1: Most Viewed, 2: Recommended
  int _currentFeaturedCarouselIndex = 0;
  int _currentGuidesCarouselIndex = 0;
  int _currentTrendingCarouselIndex = 0;
  final PageController _featuredPageController = PageController();
  final PageController _guidesPageController = PageController();
  final PageController _trendingPageController = PageController();
  final ScrollController _popularDestinationsController = ScrollController();

  @override
  void dispose() {
    _featuredPageController.dispose();
    _guidesPageController.dispose();
    _trendingPageController.dispose();
    _popularDestinationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061024),
      body: _selectedIndex == 0
          ? SafeArea(child: _buildHomePage())
          : _buildPlaceholder(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildPlaceholder() {
    Widget screen;
    switch (_selectedIndex) {
      case 1:
        screen = const SavedScreen();
        break;
      case 2:
        screen = const AddTripScreen();
        break;
      case 3:
        screen = const NotificationsScreen();
        break;
      case 4:
        screen = const ProfileScreen();
        break;
      default:
        screen = const SizedBox();
    }
    return SafeArea(bottom: false, child: screen);
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 18),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildTabs(),
          const SizedBox(height: 14),
          _buildFeaturedCarousel(),
          const SizedBox(height: 22),
          _buildQuickActions(),
          const SizedBox(height: 22),
          _buildFeaturedGuidesCarousel(),
          const SizedBox(height: 22),
          _buildPopularDestinations(),
          const SizedBox(height: 22),
          _buildFeaturedHotels(),
          const SizedBox(height: 22),
          _buildFeaturedRestaurants(),
          const SizedBox(height: 22),
          _buildTrendingPlacesCarousel(),
          const SizedBox(height: 22),
          _buildSpecialOffers(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  // Reusable iOS-like glass container
  Widget _glass({
    required Widget child,
    double borderRadius = 16,
    double blur = 12,
    Color? color,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = import_firebase_auth.FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Traveler';
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T';

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          _glass(
            borderRadius: 40,
            blur: 10,
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.transparent,
              backgroundImage: user?.photoURL != null 
                  ? NetworkImage(user!.photoURL!) 
                  : null,
              child: user?.photoURL == null 
                  ? Text(
                      firstLetter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $displayName',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: const Text(
                        'Find your next adventure',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _glass(
                      borderRadius: 12,
                      blur: 6,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.white.withOpacity(0.85),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Milano',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExploreScreen()),
            );
          },
          child: _glass(
            borderRadius: 14,
            blur: 8,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.white.withOpacity(0.75)),
                const SizedBox(width: 12),
                Text(
                  'Discover a city, landmark or guide',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.tune,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          _buildTab('Popular', 0),
          const SizedBox(width: 10),
          _buildTab('Most Viewed', 1),
          const SizedBox(width: 10),
          _buildTab('Recommended', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTab == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedTab = index;
          _currentFeaturedCarouselIndex = 0;
          _featuredPageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blue[400]
                : Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(22),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue[400]!.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.65),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    // Different content based on selected tab
    final Map<int, List<Map<String, dynamic>>> tabContent = {
      0: [
        // Popular
        {
          'name': 'Sylhet',
          'location': 'Bangladesh',
          'image':
              'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800',
          'description': 'Scotland of the East',
          'rating': '4.9',
          'reviews': '2.1k',
        },
        {
          'name': 'Coxs Bazar',
          'location': 'Bangladesh',
          'image':
              'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
          'description': 'Beach Paradise',
          'rating': '4.8',
          'reviews': '3.5k',
        },
        {
          'name': 'Bandarban',
          'location': 'Bangladesh',
          'image':
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          'description': 'Heaven on Earth',
          'rating': '4.7',
          'reviews': '1.8k',
        },
      ],
      1: [
        // Most Viewed
        {
          'name': 'Rome',
          'location': 'Italy',
          'image':
              'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800',
          'description': 'Historic Wonders',
          'rating': '4.9',
          'reviews': '5.2k',
        },
        {
          'name': 'Paris',
          'location': 'France',
          'image':
              'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
          'description': 'City of Love',
          'rating': '4.8',
          'reviews': '4.7k',
        },
        {
          'name': 'Tokyo',
          'location': 'Japan',
          'image':
              'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800',
          'description': 'Modern Metropolis',
          'rating': '4.6',
          'reviews': '3.9k',
        },
      ],
      2: [
        // Recommended
        {
          'name': 'Santorini',
          'location': 'Greece',
          'image':
              'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800',
          'description': 'Island Paradise',
          'rating': '4.9',
          'reviews': '2.8k',
        },
        {
          'name': 'Maldives',
          'location': 'Indo Ocean',
          'image':
              'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          'description': 'Crystal Waters',
          'rating': '4.8',
          'reviews': '1.9k',
        },
        {
          'name': 'Dubai',
          'location': 'UAE',
          'image':
              'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=800',
          'description': 'Desert Luxury',
          'rating': '4.7',
          'reviews': '3.1k',
        },
      ],
    };

    final currentDestinations = tabContent[_selectedTab] ?? tabContent[0]!;

    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _featuredPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentFeaturedCarouselIndex = index;
                  });
                },
                itemCount: currentDestinations.length,
                itemBuilder: (context, index) {
                  final destination = currentDestinations[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.45),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(destination['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // subtle dark gradient
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {},
                              child: _glass(
                                borderRadius: 24,
                                blur: 6,
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination['description']!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.88),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      destination['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _glass(
                                    borderRadius: 12,
                                    blur: 6,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          destination['rating']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '(${destination['reviews']})',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.85,
                                            ),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShillongDetailsScreen(
                                              destinationName:
                                                  destination['name']!,
                                              imageUrl: destination['image']!,
                                              location: destination['location'],
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[400],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Explore ${destination['name']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Left navigation
            if (_currentFeaturedCarouselIndex > 0)
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _featuredPageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            // Right navigation
            if (_currentFeaturedCarouselIndex < currentDestinations.length - 1)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _featuredPageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            currentDestinations.length,
            (index) => GestureDetector(
              onTap: () {
                _featuredPageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentFeaturedCarouselIndex == index ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentFeaturedCarouselIndex == index
                      ? Colors.blue[400]
                      : Colors.white.withOpacity(0.24),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedGuidesCarousel() {
    final guides = [
      {
        'name': 'Malaga, Spain',
        'subtitle': 'Scenic view of the Western Mediterranean...',
        'author': 'Allan Walt',
        'views': '5.3k',
        'image':
            'https://images.unsplash.com/photo-1583422409516-2895a77efded?w=400',
      },
      {
        'name': 'Bali, Indonesia',
        'subtitle': 'Tropical paradise with stunning beaches...',
        'author': 'Sarah Chen',
        'views': '8.1k',
        'image':
            'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
      },
      {
        'name': 'Paris, France',
        'subtitle': 'City of lights and romantic getaways...',
        'author': 'Michel Dubois',
        'views': '12.5k',
        'image':
            'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=400',
      },
      {
        'name': 'Tokyo, Japan',
        'subtitle': 'Modern metropolis meets ancient culture...',
        'author': 'Yuki Tanaka',
        'views': '9.7k',
        'image':
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
      },
      {
        'name': 'Dubai, UAE',
        'subtitle': 'Luxury and modern architecture...',
        'author': 'Ahmed Hassan',
        'views': '7.2k',
        'image':
            'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      },
      {
        'name': 'London, UK',
        'subtitle': 'Historic landmarks and vibrant culture...',
        'author': 'James Smith',
        'views': '10.1k',
        'image':
            'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400',
      },
      {
        'name': 'New York, USA',
        'subtitle': 'The city that never sleeps...',
        'author': 'John Davis',
        'views': '15.3k',
        'image':
            'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured Guide Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _guidesPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentGuidesCarouselIndex = index;
                  });
                },
                itemCount: (guides.length / 2).ceil(),
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * 2;
                  final endIndex = (startIndex + 2) < guides.length
                      ? (startIndex + 2)
                      : guides.length;
                  final pageGuides = guides.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: pageGuides.map((guide) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildGuideCard(
                              name: guide['name']!,
                              subtitle: guide['subtitle']!,
                              author: guide['author']!,
                              views: guide['views']!,
                              image: guide['image']!,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            // Left navigation button
            if (_currentGuidesCarouselIndex > 0)
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _guidesPageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Right navigation button
            if (_currentGuidesCarouselIndex < (guides.length / 2).ceil() - 1)
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _guidesPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (guides.length / 2).ceil(),
            (index) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _guidesPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentGuidesCarouselIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentGuidesCarouselIndex == index
                        ? Colors.blue[600]
                        : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideCard({
    required String name,
    required String subtitle,
    required String author,
    required String views,
    required String image,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 14),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            author,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '$views views',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final destinations = [
      {
        'name': 'San Francisco',
        'image':
            'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=300',
      },
      {
        'name': 'Tokyo',
        'image':
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300',
      },
      {
        'name': 'Toronto',
        'image':
            'https://images.unsplash.com/photo-1517935706615-2717063c2225?w=300',
      },
      {
        'name': 'Scotland',
        'image':
            'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=300',
      },
      {
        'name': 'San Francisco',
        'image':
            'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=300',
      },
      {
        'name': 'Tokyo',
        'image':
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300',
      },
      {
        'name': 'Toronto',
        'image':
            'https://images.unsplash.com/photo-1517935706615-2717063c2225?w=300',
      },
      {
        'name': 'Scotland',
        'image':
            'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=300',
      },
      {
        'name': 'San Francisco',
        'image':
            'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=300',
      },
      {
        'name': 'Tokyo',
        'image':
            'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=300',
      },
      {
        'name': 'Toronto',
        'image':
            'https://images.unsplash.com/photo-1517935706615-2717063c2225?w=300',
      },
      {
        'name': 'Scotland',
        'image':
            'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=300',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Destinations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExploreScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Show all',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return _buildDestinationChip(
                destinations[index]['name']!,
                destinations[index]['image']!,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationChip(String name, String image) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResortDetailsScreen(
                resortName: name,
                location: 'Popular Destination',
                imageUrl: image,
                rating: 4.8,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(Icons.flight, 'Flights', Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(Icons.hotel, 'Hotels', Colors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(Icons.restaurant, 'Food', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  Icons.directions_car,
                  'Transport',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (title == 'Hotels') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HotelDetailScreen(
                  hotelName: 'Star Pacific Sylhet',
                  location: 'Sylhet, Bangladesh',
                  rating: 4.8,
                  reviews: 156,
                  imageUrl:
                      'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
                  price: 120,
                  type: 'hotel',
                ),
              ),
            );
          }
        },
        child: _glass(
          borderRadius: 12,
          blur: 6,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingPlacesCarousel() {
    final places = [
      {
        'name': 'Manali',
        'rating': '4.8',
        'image':
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      },
      {
        'name': 'Rishikesh',
        'rating': '4.7',
        'image':
            'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=400',
      },
      {
        'name': 'Udaipur',
        'rating': '4.9',
        'image':
            'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
      },
      {
        'name': 'Hampi',
        'rating': '4.6',
        'image':
            'https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=400',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending Places',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'View all',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _trendingPageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentTrendingCarouselIndex = index;
                  });
                },
                itemCount: (places.length / 2).ceil(),
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * 2;
                  final endIndex = (startIndex + 2) < places.length
                      ? (startIndex + 2)
                      : places.length;
                  final pagePlaces = places.sublist(startIndex, endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: pagePlaces.map((place) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildTrendingCard(place),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            // Left navigation button
            if (_currentTrendingCarouselIndex > 0)
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _trendingPageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Right navigation button
            if (_currentTrendingCarouselIndex < (places.length / 2).ceil() - 1)
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _trendingPageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (places.length / 2).ceil(),
            (index) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _trendingPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentTrendingCarouselIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentTrendingCarouselIndex == index
                        ? Colors.blue[600]
                        : Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(Map<String, String> place) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(place['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          place['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              place['rating']!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedHotels() {
    final hotels = [
      {
        'name': 'Star Pacific Sylhet',
        'location': 'Sylhet, Bangladesh',
        'rating': 4.8,
        'reviews': 156,
        'price': 120,
        'image':
            'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      },
      {
        'name': 'Grand Luxury Hotel',
        'location': 'Dhaka, Bangladesh',
        'rating': 4.6,
        'reviews': 203,
        'price': 95,
        'image':
            'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
      },
      {
        'name': 'Ocean View Resort',
        'location': 'Cox\'s Bazar, Bangladesh',
        'rating': 4.9,
        'reviews': 312,
        'price': 150,
        'image':
            'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Hotels',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HotelsListScreen(category: 'hotel'),
                      ),
                    );
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              return _buildHotelCard(hotels[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailScreen(
                hotelName: hotel['name'],
                location: hotel['location'],
                rating: hotel['rating'],
                reviews: hotel['reviews'],
                imageUrl: hotel['image'],
                price: hotel['price'].toDouble(),
                type: 'hotel',
              ),
            ),
          );
        },
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(hotel['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            hotel['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel['location'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${hotel['price']}/night',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${hotel['reviews']} reviews',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedRestaurants() {
    final restaurants = [
      {
        'name': 'City Hut Family Dhaba',
        'location': 'Sylhet, Bangladesh',
        'rating': 4.9,
        'reviews': 234,
        'price': 25,
        'type': 'restaurant',
        'image':
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      },
      {
        'name': 'Panshi Restaurant',
        'location': 'Dhaka, Bangladesh',
        'rating': 4.7,
        'reviews': 189,
        'price': 30,
        'type': 'restaurant',
        'image':
            'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400',
      },
      {
        'name': 'Cafe Mango',
        'location': 'Cox\'s Bazar, Bangladesh',
        'rating': 4.8,
        'reviews': 156,
        'price': 15,
        'type': 'cafe',
        'image':
            'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Restaurants & Cafes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HotelsListScreen(category: 'all'),
                      ),
                    );
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantCard(restaurants[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDetailScreen(
                hotelName: restaurant['name'],
                location: restaurant['location'],
                rating: restaurant['rating'],
                reviews: restaurant['reviews'],
                imageUrl: restaurant['image'],
                price: restaurant['price'].toDouble(),
                type: restaurant['type'],
              ),
            ),
          );
        },
        child: Container(
          width: 280,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(restaurant['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: restaurant['type'] == 'cafe'
                            ? Colors.orange.withOpacity(0.9)
                            : Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        restaurant['type'] == 'cafe' ? 'CAFE' : 'RESTAURANT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['rating'].toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant['location'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${restaurant['price']} avg',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${restaurant['reviews']} reviews',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Special Offers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[600]!, Colors.blue[600]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Summer Sale',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Get up to 50% off on selected destinations',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Book Now',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 48,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0, filled: true),
              _buildNavItem(Icons.favorite_border, 'Saved', 1),
              _buildCenterAddButton(),
              _buildNavItem(Icons.notifications_none, 'Notification', 3),
              _buildNavItem(Icons.person_outline, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterAddButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = 2),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[600],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index, {
    bool filled = false,
  }) {
    final isSelected = _selectedIndex == index;
    return Flexible(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
