import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = _mockNotifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Notification Summary
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You have ${_getUnreadCount()} unread notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Stay updated with your SGX activities',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Notifications List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationItem(notification, index);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification, int index) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          notifications.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _onNotificationTap(notification, index),
        child: Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Color(0xFFF0F8F0),
            borderRadius: BorderRadius.circular(12),
            border: notification.isRead
                ? Border.all(color: Colors.grey[200]!)
                : Border.all(color: Color(0xFF4CAF50).withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      _getNotificationColor(notification.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: Color(0xFF2E2E2E),
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.timestamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        if (notification.actionText != null)
                          GestureDetector(
                            onTap: () => _onActionTap(notification),
                            child: Text(
                              notification.actionText!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4CAF50),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none,
              size: 60,
              color: Color(0xFF4CAF50),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up!\nWe\'ll notify you when something new happens.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.ride:
        return Icons.electric_rickshaw;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.system:
        return Icons.info_outline;
      case NotificationType.security:
        return Icons.security;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.ride:
        return Color(0xFF4CAF50);
      case NotificationType.payment:
        return Color(0xFF2196F3);
      case NotificationType.promotion:
        return Color(0xFFFF9800);
      case NotificationType.system:
        return Color(0xFF9C27B0);
      case NotificationType.security:
        return Color(0xFFF44336);
      default:
        return Color(0xFF757575);
    }
  }

  int _getUnreadCount() {
    return notifications.where((n) => !n.isRead).length;
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onNotificationTap(NotificationItem notification, int index) {
    setState(() {
      notifications[index].isRead = true;
    });

    // Handle navigation based on notification type
    switch (notification.type) {
      case NotificationType.ride:
        // Navigate to ride details
        break;
      case NotificationType.payment:
        // Navigate to payment history
        break;
      case NotificationType.promotion:
        // Navigate to promotions
        break;
      default:
        break;
    }
  }

  void _onActionTap(NotificationItem notification) {
    // Handle action button tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action: ${notification.actionText}'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

enum NotificationType {
  ride,
  payment,
  promotion,
  system,
  security,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final NotificationType type;
  bool isRead;
  final String? actionText;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionText,
  });
}

final List<NotificationItem> _mockNotifications = [
  NotificationItem(
    id: '1',
    title: 'Ride Completed',
    message:
        'Your ride from Makati to BGC has been completed. Total fare: ₱85.50',
    timestamp: '2 minutes ago',
    type: NotificationType.ride,
    isRead: false,
    actionText: 'View Details',
  ),
  NotificationItem(
    id: '2',
    title: 'Payment Successful',
    message: 'Your wallet has been topped up with ₱500.00 via GCash',
    timestamp: '1 hour ago',
    type: NotificationType.payment,
    isRead: false,
    actionText: 'View Receipt',
  ),
  NotificationItem(
    id: '3',
    title: '50% Off Weekend Rides!',
    message: 'Get 50% discount on all rides this weekend. Limited time offer!',
    timestamp: '3 hours ago',
    type: NotificationType.promotion,
    isRead: true,
    actionText: 'Claim Now',
  ),
  NotificationItem(
    id: '4',
    title: 'Referral Bonus Earned',
    message:
        'You earned ₱50 bonus for referring John Doe. Keep inviting friends!',
    timestamp: 'Yesterday',
    type: NotificationType.payment,
    isRead: true,
  ),
  NotificationItem(
    id: '5',
    title: 'Security Alert',
    message:
        'New device login detected. If this wasn\'t you, please secure your account.',
    timestamp: '2 days ago',
    type: NotificationType.security,
    isRead: false,
    actionText: 'Review',
  ),
  NotificationItem(
    id: '6',
    title: 'App Update Available',
    message: 'Version 2.1.0 is now available with new features and bug fixes.',
    timestamp: '3 days ago',
    type: NotificationType.system,
    isRead: true,
    actionText: 'Update',
  ),
  NotificationItem(
    id: '7',
    title: 'Weekly Summary',
    message:
        'You completed 12 rides this week and saved ₱200 compared to traditional transport.',
    timestamp: '1 week ago',
    type: NotificationType.system,
    isRead: true,
  ),
];
