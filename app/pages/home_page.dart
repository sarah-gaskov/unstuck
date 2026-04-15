import 'package:flutter/material.dart';
import '../api_service.dart';
import 'ask_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();
  List boardData = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    List data = await api.getBoard();
    setState(() {
      boardData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Questions'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Awaiting Actions'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('My Questions'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('My Answers'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: inquiries.length,
        itemBuilder: (context, index) {
          final item = inquiries[index];
          final inquiryAnswers = getAnswersForInquiry(item['inquiry_id']);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['title'] ?? 'No title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item['body'] ?? ''),
                  if (inquiryAnswers.isNotEmpty) ...[
                    const Divider(),
                    const Text('Answers:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ...inquiryAnswers.map((answer) => Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text('• ${answer['body']}'),
                    )),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AskPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}