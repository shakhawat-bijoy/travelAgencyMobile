import 'package:flutter/material.dart';
import 'tourist_spots.dart';
import 'saved_screen.dart';
import 'add_trip_screen.dart';
import 'notifications_screen.dart';
import 'explore_screen.dart';
import 'profile_screen.dart';

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
      backgroundColor: const Color(0xFF0A1628),
      body: _selectedIndex == 0
          ? SafeArea(child: _buildHomePage())
          : _buildPlaceholder(),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0
          ? MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FloatingActionButton(
                onPressed: () => setState(() => _selectedIndex = 2),
                backgroundColor: Colors.blue[600],
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildPlaceholder() {
    switch (_selectedIndex) {
      case 1:
        return const SavedScreen();
      case 2:
        return const AddTripScreen();
      case 3:
        return const NotificationsScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildTabs(),
          const SizedBox(height: 16),
          _buildFeaturedCarousel(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildFeaturedGuidesCarousel(),
          const SizedBox(height: 24),
          _buildPopularDestinations(),
          const SizedBox(height: 24),
          _buildTrendingPlacesCarousel(),
          const SizedBox(height: 24),
          _buildSpecialOffers(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.amber,
            child: Text(
              'HM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi Heer',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  'Good Afternoon',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ExploreScreen()),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A2642),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Discover a city',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.tune, color: Colors.white.withValues(alpha: 0.7)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildTab('Popular', 0),
          const SizedBox(width: 12),
          _buildTab('Most Viewed', 1),
          const SizedBox(width: 12),
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[600] : const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
          'description': 'Tropical Paradise',
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
              height: 240,
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(destination['image']!),
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
                                Colors.black.withValues(alpha: 0.7),
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
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 20,
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
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      destination['name']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          destination['rating']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${destination['reviews']})',
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 10,
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
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Explore ${destination['name']}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: Colors.black,
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
            // Left navigation button
            if (_currentFeaturedCarouselIndex > 0)
              Positioned(
                left: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
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
            if (_currentFeaturedCarouselIndex < currentDestinations.length - 1)
              Positioned(
                right: 10,
                top: 0,
                bottom: 0,
                child: Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
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
            currentDestinations.length,
            (index) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  _featuredPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentFeaturedCarouselIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentFeaturedCarouselIndex == index
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

  Widget _buildFeaturedGuidesCarousel() {
    final guides = [
      {
        'name': 'Malaga, Spain',
        'subtitle': 'Scenic view of the Western Mediterranean...',
        'author': 'Allan Walt',
        'views': '5.3k',
        'image':
            'https://images.unsplash.com/photo-1580837119756-563d608dd119?w=400',
      },
      {
        'name': 'Bali, Indonesia',
        'subtitle': 'Tropical paradise with stunning beaches...',
        'author': 'Sarah Chen',
        'views': '8.1k',
        'image':
            'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400',
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
        'name': 'Bali, Indonesia',
        'subtitle': 'Tropical paradise with stunning beaches...',
        'author': 'Sarah Chen',
        'views': '8.1k',
        'image':
            'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400',
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
        onTap: () {},
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
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
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
                  fontWeight: FontWeight.w500,
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
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              place['rating']!,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
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
                                    fontWeight: FontWeight.w600,
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
        color: const Color(0xFF1A2642),
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
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.favorite_border, 'Saved', 1),
              const SizedBox(width: 60), // Space for FAB
              _buildNavItem(Icons.notifications_outlined, 'Notifications', 3),
              _buildNavItem(Icons.person_outline, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Flexible(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue[600]!.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? Colors.blue[400]
                      : Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.blue[400]
                        : Colors.white.withValues(alpha: 0.5),
                    fontSize: 9,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
