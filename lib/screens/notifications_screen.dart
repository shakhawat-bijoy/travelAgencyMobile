import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Trip Reminder',
      'message':
          'Your trip to Shillong starts tomorrow! Don\'t forget to pack your essentials.',
      'time': '2 hours ago',
      'type': 'trip',
      'isRead': false,
      'icon': Icons.flight_takeoff,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'New Destination Added',
      'message':
          'Cox\'s Bazar Beach has been added to your wishlist. Check out the amazing reviews!',
      'time': '5 hours ago',
      'type': 'wishlist',
      'isRead': false,
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'id': '3',
      'title': 'Weather Update',
      'message':
          'Perfect weather for your Malaga trip! Sunny with 25°C temperature.',
      'time': '1 day ago',
      'type': 'weather',
      'isRead': true,
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
    },
    {
      'id': '4',
      'title': 'Booking Confirmation',
      'message':
          'Your hotel booking at City Hut Family Dhaba has been confirmed.',
      'time': '2 days ago',
      'type': 'booking',
      'isRead': true,
      'icon': Icons.hotel,
      'color': Colors.green,
    },
    {
      'id': '5',
      'title': 'Special Offer',
      'message':
          'Get 30% off on your next booking! Limited time offer expires in 3 days.',
      'time': '3 days ago',
      'type': 'offer',
      'isRead': true,
      'icon': Icons.local_offer,
      'color': Colors.purple,
    },
    {
      'id': '6',
      'title': 'Review Reminder',
      'message':
          'How was your experience at Tokyo? Share your review and help other travelers.',
      'time': '1 week ago',
      'type': 'review',
      'isRead': true,
      'icon': Icons.star,
      'color': Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$unreadCount new',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _markAllAsRead,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2642),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.done_all,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildFilterTab('All', true),
          const SizedBox(width: 12),
          _buildFilterTab('Unread', false),
          const SizedBox(width: 12),
          _buildFilterTab('Important', false),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Filter logic would go here
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[600] : const Color(0xFF1A2642),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
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
              Icons.notifications_none,
              size: 60,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you about important updates',
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

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(notifications[index], index);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead']
            ? const Color(0xFF1A2642)
            : const Color(0xFF1A2642).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: notification['isRead']
            ? null
            : Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Dismissible(
        key: Key(notification['id']),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (direction) {
          setState(() {
            notifications.removeAt(index);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${notification['title']} dismissed'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  setState(() {
                    notifications.insert(index, notification);
                  });
                },
              ),
            ),
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _markAsRead(index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: notification['color'].withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      notification['icon'],
                      color: notification['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: notification['isRead']
                                      ? FontWeight.w500
                                      : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!notification['isRead'])
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['message'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification['time'],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _markAsRead(int index) {
    setState(() {
      notifications[index]['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }
}
