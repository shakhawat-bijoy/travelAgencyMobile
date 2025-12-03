import 'package:flutter/material.dart';
import 'hotel_detail_screen.dart';

class HotelsListScreen extends StatefulWidget {
  final String? category; // 'all', 'hotels', 'restaurants', 'cafes'

  const HotelsListScreen({super.key, this.category = 'all'});

  @override
  State<HotelsListScreen> createState() => _HotelsListScreenState();
}

class _HotelsListScreenState extends State<HotelsListScreen> {
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? 'all';
  }

  final List<Map<String, dynamic>> allEstablishments = [
    // Hotels
    {
      'name': 'Star Pacific Sylhet',
      'location': 'Sylhet, Bangladesh',
      'rating': 4.8,
      'reviews': 156,
      'price': 120,
      'type': 'hotel',
      'image':
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400',
      'description':
          'Luxury hotel with world-class amenities in the heart of Sylhet.',
    },
    {
      'name': 'Grand Luxury Hotel',
      'location': 'Dhaka, Bangladesh',
      'rating': 4.6,
      'reviews': 203,
      'price': 95,
      'type': 'hotel',
      'image':
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400',
      'description': 'Modern hotel with excellent service and facilities.',
    },
    {
      'name': 'Ocean View Resort',
      'location': 'Cox\'s Bazar, Bangladesh',
      'rating': 4.9,
      'reviews': 312,
      'price': 150,
      'type': 'hotel',
      'image':
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400',
      'description': 'Beachfront resort with stunning ocean views.',
    },
    {
      'name': 'Royal Palace Hotel',
      'location': 'Chittagong, Bangladesh',
      'rating': 4.7,
      'reviews': 189,
      'price': 110,
      'type': 'hotel',
      'image':
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?w=400',
      'description': 'Elegant hotel with royal treatment and comfort.',
    },
    // Restaurants
    {
      'name': 'City Hut Family Dhaba',
      'location': 'Sylhet, Bangladesh',
      'rating': 4.9,
      'reviews': 234,
      'price': 25,
      'type': 'restaurant',
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'description': 'Traditional dhaba with authentic local cuisine.',
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
      'description': 'Fine dining with a blend of traditional and modern.',
    },
    {
      'name': 'Spice Garden',
      'location': 'Chittagong, Bangladesh',
      'rating': 4.8,
      'reviews': 167,
      'price': 35,
      'type': 'restaurant',
      'image':
          'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      'description': 'Exotic spices and flavors in every dish.',
    },
    {
      'name': 'The Grill House',
      'location': 'Sylhet, Bangladesh',
      'rating': 4.6,
      'reviews': 145,
      'price': 40,
      'type': 'restaurant',
      'image':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
      'description': 'Premium grilled meats and seafood.',
    },
    // Cafes
    {
      'name': 'Cafe Mango',
      'location': 'Cox\'s Bazar, Bangladesh',
      'rating': 4.8,
      'reviews': 156,
      'price': 15,
      'type': 'cafe',
      'image':
          'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400',
      'description': 'Cozy beachside cafe with fresh tropical drinks.',
    },
    {
      'name': 'Coffee Corner',
      'location': 'Dhaka, Bangladesh',
      'rating': 4.7,
      'reviews': 198,
      'price': 12,
      'type': 'cafe',
      'image':
          'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400',
      'description': 'Artisan coffee and homemade pastries.',
    },
    {
      'name': 'Tea Time Lounge',
      'location': 'Sylhet, Bangladesh',
      'rating': 4.5,
      'reviews': 134,
      'price': 10,
      'type': 'cafe',
      'image':
          'https://images.unsplash.com/photo-1559305616-3b04e37e3b60?w=400',
      'description': 'Traditional tea house with modern ambiance.',
    },
    {
      'name': 'Brew & Bites',
      'location': 'Chittagong, Bangladesh',
      'rating': 4.6,
      'reviews': 142,
      'price': 18,
      'type': 'cafe',
      'image':
          'https://images.unsplash.com/photo-1453614512568-c4024d13c247?w=400',
      'description': 'Specialty coffee and gourmet sandwiches.',
    },
  ];

  List<Map<String, dynamic>> get filteredEstablishments {
    if (_selectedCategory == 'all') {
      return allEstablishments;
    }
    return allEstablishments
        .where((item) => item['type'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Browse Places',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(
            child: filteredEstablishments.isEmpty
                ? _buildEmptyState()
                : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryTab('All', 'all', Icons.apps),
            const SizedBox(width: 12),
            _buildCategoryTab('Hotels', 'hotel', Icons.hotel),
            const SizedBox(width: 12),
            _buildCategoryTab('Restaurants', 'restaurant', Icons.restaurant),
            const SizedBox(width: 12),
            _buildCategoryTab('Cafes', 'cafe', Icons.coffee),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String label, String category, IconData icon) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : const Color(0xFF1A2642),
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.blue[400]!, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.6),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filteredEstablishments.length,
      itemBuilder: (context, index) {
        return _buildEstablishmentCard(filteredEstablishments[index]);
      },
    );
  }

  Widget _buildEstablishmentCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailScreen(
              hotelName: item['name'],
              location: item['location'],
              rating: item['rating'],
              reviews: item['reviews'],
              imageUrl: item['image'],
              price: item['price'].toDouble(),
              type: item['type'],
              description: item['description'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2642),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(item['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item['type'] == 'hotel'
                            ? Colors.blue.withOpacity(0.9)
                            : item['type'] == 'restaurant'
                            ? Colors.green.withOpacity(0.9)
                            : Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['type'].toString().toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
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
                            item['location'],
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
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
                                item['rating'].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item['reviews']} reviews',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${item['price']} ${item['type'] == 'hotel' ? '/night' : 'avg'}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Favorite button
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
