import 'package:flutter/material.dart';
import '../api_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

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
    List data = await api.getNotifications();
    setState(() {
      notifications = data;
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
                return ListTile(
                  leading: Icon(
                    item['is_read'] == true
                        ? Icons.notifications_none
                        : Icons.notifications,
                    color: item['is_read'] == true
                        ? Colors.grey
                        : Colors.deepPurple,
                  ),
                  title: Text(item['message'] ?? 'No message'),
                  subtitle: Text(item['created_at'] ?? ''),
                );
              },
            ),
    );
  }
}