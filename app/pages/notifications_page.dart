import 'package:flutter/material.dart';
import '../api_service.dart';

class NotificationsPage extends StatefulWidget {
  final String userId;
  const NotificationsPage({super.key, required this.userId});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ApiService api = ApiService();
  List notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    List data = await api.getNotifications(widget.userId);
    setState(() {
      notifications = data;
    });
  }

  Future<void> _markRead(int id, int index) async {
    await api.markNotificationRead(id);
    setState(() {
      notifications[index] = Map.from(notifications[index])..['is_read'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awaiting Actions'),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final bool isRead = item['is_read'] == true;
                return ListTile(
                  leading: Icon(
                    isRead ? Icons.notifications_none : Icons.notifications,
                    color: isRead ? Colors.grey : Colors.deepPurple,
                  ),
                  title: Text(item['message'] ?? 'No message'),
                  subtitle: Text(item['created_at'] ?? ''),
                  onTap: isRead
                      ? null
                      : () => _markRead(item['notification_id'], index),
                );
              },
            ),
    );
  }
}
