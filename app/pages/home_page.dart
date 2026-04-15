import 'package:flutter/material.dart';
import '../api_service.dart';
import 'ask_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String userId;
  const HomePage({super.key, required this.username, required this.userId});

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
  
  Future<void> _showAnswerDialog(int inquiryId) async {
	TextEditingController answerController = TextEditingController();
	return showDialog(
		context: context,
		builder: (context) {
			return AlertDialog(
				title: const Text('Add Answer'),
				content: TextField(
					controller: answerController,
					decoration: const InputDecoration(hintText: 'Type your answer here...'),
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
								await api.addAnswer(inquiryId, answerController.text, widget.userId);
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
              onTap: () async {
				if (widget.username.startsWith('Guest_')) { //TODO: include better condition... what if someone made their username this?
					await api.deleteGuest(widget.username);
				}
				
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
      body: ListView.builder(
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
					onPressed: () {
						_showAnswerDialog(item['inquiry_id']);
					},
				   ),
				  ],
				 ),
				  
                  const SizedBox(height: 4),
                  Text(item['body'] ?? ''),
                  if (answers.isNotEmpty) ...[
                    const Divider(),
                    const Text('Answers:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ...answers.map((answer) => Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text('• ${answer['username'] ?? 'Unknown'}: ${answer['body']}'),
                    )),
                  ],
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AskPage()),
          );
		  
		  loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}