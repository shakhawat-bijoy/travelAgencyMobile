import 'package:flutter/material.dart';
import 'tourist_spots.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Restaurants',
    'Cheap Eats',
    'Cafes',
    'Attractions',
    'Hotels',
    'Shopping',
    'Nightlife',
  ];

  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Cox\'s Bazar Beach',
      'location': 'Bangladesh',
      'category': 'Attractions',
      'rating': 4.9,
      'reviews': '1.1k',
      'image':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'description':
          'World\'s longest natural sea beach with crystal clear water',
      'price': '\$50-100',
      'isOpen': true,
    },
    {
      'name': 'Sylhet Museum Ln',
      'location': 'Sylhet, Bangladesh',
      'category': 'Attractions',
      'rating': 4.5,
      'reviews': '856',
      'image':
          'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=400',
      'description': 'Historical museum showcasing local culture and heritage',
      'price': '\$10-25',
      'isOpen': true,
    },
    {
      'name': 'City Hut Family Dhaba',
      'location': 'Dhaka, Bangladesh',
      'category': 'Restaurants',
      'rating': 4.9,
      'reviews': '2.3k',
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'description': 'Casual dhaba with palm-frond roof and local food',
      'price': '\$15-30',
      'isOpen': true,
    },
    {
      'name': 'Shillong Peak Cafe',
      'location': 'Shillong, India',
      'category': 'Cafes',
      'rating': 4.7,
      'reviews': '945',
      'image':
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400',
      'description': 'Mountain cafe with panoramic views and local coffee',
      'price': '\$8-20',
      'isOpen': false,
    },
    {
      'name': 'Malaga Sunset Resort',
      'location': 'Malaga, Spain',
      'category': 'Hotels',
      'rating': 4.8,
      'reviews': '1.8k',
      'image':
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      'description': 'Luxury resort with Mediterranean views and spa',
      'price': '\$200-400',
      'isOpen': true,
    },
    {
      'name': 'Tokyo Street Food Market',
      'location': 'Tokyo, Japan',
      'category': 'Cheap Eats',
      'rating': 4.6,
      'reviews': '3.2k',
      'image':
          'https://images.unsplash.com/photo-1613929633738-596c40b2abb7?w=400',
      'description': 'Authentic street food experience in bustling market',
      'price': '\$5-15',
      'isOpen': true,
    },
    {
      'name': 'Le Grand Hotel Paris',
      'location': 'Paris, France',
      'category': 'Hotels',
      'rating': 4.7,
      'reviews': '2.5k',
      'image':
          'https://images.unsplash.com/photo-1502602898657-3e91760c0341?w=400',
      'description':
          'Elegant 5-star hotel near the Eiffel Tower with classic decor.',
      'price': '300-500',
      'isOpen': true,
    },
    {
      'name': 'Greenwich Village Coffee',
      'location': 'New York, USA',
      'category': 'Cafes',
      'rating': 4.6,
      'reviews': '1.2k',
      'image':
          'https://images.unsplash.com/photo-1509042239660-1a0e5f84a83c?w=400',
      'description':
          'Cozy neighborhood cafe known for artisanal espresso and pastries.',
      'price': '10-25',
      'isOpen': true,
    },
    {
      'name': 'Colosseum Tour',
      'location': 'Rome, Italy',
      'category': 'Attractions',
      'rating': 4.8,
      'reviews': '10.5k',
      'image':
          'https://images.unsplash.com/photo-1552832230-c0197936081a?w=400',
      'description': 'Guided tour of the ancient Roman amphitheater.',
      'price': '40-80',
      'isOpen': true,
    },
    {
      'name': 'Bangkok Night Market Eats',
      'location': 'Bangkok, Thailand',
      'category': 'Restaurants',
      'rating': 4.7,
      'reviews': '4.1k',
      'image':
          'https://images.unsplash.com/photo-1567119001377-690E8c874695?w=400',
      'description':
          'Vibrant street food stalls offering authentic Thai cuisine.',
      'price': '5-20',
      'isOpen': true,
    },
    {
      'name': 'The Nile Cruise',
      'location': 'Luxor, Egypt',
      'category': 'Attractions',
      'rating': 4.9,
      'reviews': '3.1k',
      'image':
          'https://images.unsplash.com/photo-1568323214312-32d56c00d437?w=400',
      'description':
          'Multi-day cruise viewing ancient temples between Luxor and Aswan.',
      'price': '400-800',
      'isOpen': true,
    },
    {
      'name': 'Sydney Opera House',
      'location': 'Sydney, Australia',
      'category': 'Attractions',
      'rating': 4.8,
      'reviews': '12.2k',
      'image':
          'https://images.unsplash.com/photo-1523049673857-C2ed8f139845?w=400',
      'description':
          'Iconic multi-venue performing arts center on Sydney Harbour.',
      'price': '30-70',
      'isOpen': true,
    },
    {
      'name': 'El Calafate Glamping',
      'location': 'Patagonia, Argentina',
      'category': 'Hotels',
      'rating': 4.9,
      'reviews': '990',
      'image':
          'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400',
      'description':
          'Luxury dome tents with stunning views of the Patagonian ice fields.',
      'price': '250-450',
      'isOpen': true,
    },
    {
      'name': 'Marrakesh Souk',
      'location': 'Marrakesh, Morocco',
      'category': 'Cheap Eats',
      'rating': 4.6,
      'reviews': '5.5k',
      'image':
          'https://images.unsplash.com/photo-1567914041138-0678887b08b1?w=400',
      'description':
          'Bustling market with tagine stalls, spices, and handcrafted goods.',
      'price': '5-25',
      'isOpen': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredDestinations {
    var filtered = destinations;

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((d) => d['category'] == _selectedCategory)
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (d) =>
                d['name'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                d['location'].toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryTabs(),
            _buildTopPlacesSection(),
            Expanded(child: _buildDestinationsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2642),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s On Your Mind?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Perfect. Grab a deal.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2642),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 20,
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A2642),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Search destinations, restaurants...',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(
                      Icons.tune,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue[600]
                        : const Color(0xFF1A2642),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.6),
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopPlacesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Places Shillong',
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
                    'See all',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final topPlaces = [
                  {
                    'name': 'Cox\'s Bazar Beach',
                    'rating': '4.9',
                    'image':
                        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300',
                  },
                  {
                    'name': 'Sylhet Museum Ln',
                    'rating': '4.5',
                    'image':
                        'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=300',
                  },
                  {
                    'name': 'Shillong Peak',
                    'rating': '4.7',
                    'image':
                        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
                  },
                  {
                    'name': 'Bercelona',
                    'rating': '4.9',
                    'image':
                        'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=300',
                  },
                  {
                    'name': 'Paris',
                    'rating': '4.5',
                    'image':
                        'https://images.unsplash.com/photo-1523482580672-f109ba8cb9be?w=300',
                  },
                  {
                    'name': 'Istanbul',
                    'rating': '4.7',
                    'image':
                        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
                  },
                ];
                return _buildTopPlaceCard(topPlaces[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPlaceCard(Map<String, String> place) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(place['image']!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    place['rating']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              place['name']!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsList() {
    final filtered = filteredDestinations;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No destinations found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildDestinationCard(filtered[index]);
      },
    );
  }

  Widget _buildDestinationCard(Map<String, dynamic> destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2642),
        borderRadius: BorderRadius.circular(16),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShillongDetailsScreen(
                  destinationName: destination['name'],
                  imageUrl: destination['image'],
                  location: destination['location'],
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(destination['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 16,
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
                        color: destination['isOpen']
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        destination['isOpen'] ? 'Open' : 'Closed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            destination['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          destination['price'],
                          style: TextStyle(
                            color: Colors.blue[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination['location'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      destination['description'],
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              destination['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${destination['reviews']} reviews)',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            destination['category'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Restaurants':
        return Icons.restaurant;
      case 'Cheap Eats':
        return Icons.fastfood;
      case 'Cafes':
        return Icons.local_cafe;
      case 'Attractions':
        return Icons.place;
      case 'Hotels':
        return Icons.hotel;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Nightlife':
        return Icons.nightlife;
      default:
        return Icons.explore;
    }
  }
}
