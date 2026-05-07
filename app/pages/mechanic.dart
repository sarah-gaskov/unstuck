import 'package:flutter/material.dart';
import '../api_service.dart';
import 'ask_page.dart';
import 'login_page.dart';

class MechanicHomePage extends StatefulWidget {
  final String username;
  final String userId;

  const MechanicHomePage({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  State<MechanicHomePage> createState() => _MechanicHomePageState();
}

class _MechanicHomePageState extends State<MechanicHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService api = ApiService();
  List boardData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    List data = await api.getBoard();
    setState(() {
      boardData = data;
    });
  }

  Future<void> _showAnswerDialog(int inquiryId) async {
    TextEditingController answerController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Answer'),
          content: TextField(
            controller: answerController,
            decoration:
                const InputDecoration(hintText: 'Type your answer here...'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (answerController.text.trim().isNotEmpty) {
                  await api.addAnswer(
                    inquiryId,
                    answerController.text,
                    widget.userId,
                  );
                  if (!mounted) return;
                  Navigator.pop(context);
                  loadData();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAllQuestionsTab() {
    return ListView.builder(
      itemCount: boardData.length,
      itemBuilder: (context, index) {
        final item = boardData[index];
        final answers = item['answers'] as List? ?? [];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    IconButton(
                      icon: const Icon(Icons.reply),
                      tooltip: 'Reply to question',
                      onPressed: () => _showAnswerDialog(item['inquiry_id']),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(item['body'] ?? ''),
                if (answers.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    'Answers:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  ...answers.map((answer) => Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(
                          '• ${answer['username'] ?? 'Unknown'}: ${answer['body']}',
                        ),
                      )),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerQuestionsTab() {
    final unanswered = boardData.where((item) {
      final answers = item['answers'] as List? ?? [];
      return answers.isEmpty;
    }).toList();

    if (unanswered.isEmpty) {
      return const Center(
        child: Text(
          'No pending questions !',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: unanswered.length,
      itemBuilder: (context, index) {
        final item = unanswered[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.help_outline, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['title'] ?? 'No title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item['body'] ?? ''),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Answer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showAnswerDialog(item['inquiry_id']),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A System'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.forum), text: 'All Questions'),
            Tab(icon: Icon(Icons.question_answer), text: 'Answer Questions'),
          ],
        ),
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
              onTap: () async {
                if (!mounted) return;
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllQuestionsTab(),
          _buildAnswerQuestionsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AskPage(
                      userId: widget.userId,
                      username: widget.username,
                    ),
                  ),
                );
                loadData();
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}