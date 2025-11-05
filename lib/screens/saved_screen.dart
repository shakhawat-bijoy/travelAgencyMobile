import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<Map<String, dynamic>> savedPlaces = [
    {
      'name': 'City Hut Family Dhaba',
      'type': 'Restaurant',
      'location': 'Casual Dhaba with palm-frond roof and local food',
      'image':
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
      'rating': 4.9,
      'saved': true,
    },
    {
      'name': 'Cox\'s Bazar Beach',
      'type': 'Beach',
      'location': 'World\'s longest natural sea beach',
      'image':
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'rating': 4.8,
      'saved': true,
    },
    {
      'name': 'Shillong Peak',
      'type': 'Mountain',
      'location': 'Highest point in Meghalaya with panoramic views',
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'rating': 4.7,
      'saved': true,
    },
    {
      'name': 'Malaga Sunset Point',
      'type': 'Viewpoint',
      'location': 'Scenic view of the Western Mediterranean',
      'image':
          'https://images.unsplash.com/photo-1580837119756-563d608dd119?w=400',
      'rating': 4.9,
      'saved': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Saved',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2642),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${savedPlaces.length} places',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
      body: savedPlaces.isEmpty ? _buildEmptyState() : _buildSavedList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF1A2642),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.bookmark_border,
              size: 60,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No saved places yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring and save your favorite places',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSavedList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: savedPlaces.length,
      itemBuilder: (context, index) {
        return _buildSavedCard(savedPlaces[index], index);
      },
    );
  }

  Widget _buildSavedCard(Map<String, dynamic> place, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2642),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(place['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              place['type'],
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                place['rating'].toString(),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        place['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place['location'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Save button
          Positioned(
            top: 8,
            right: 8,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    savedPlaces.removeAt(index);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: Colors.blue,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
