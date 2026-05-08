import 'package:flutter/material.dart';
import '../api_service.dart';

// this page shows a list of all the questions the logged-in user has posted
// it only shows THEIR questions, not everyone's — we filter by userId on the server
// reference: api endpoint is GET /api/my-questions/:userId in server.js

class MyQuestionsPage extends StatefulWidget {
  // we need userId to fetch only this user's questions from the server
  // we need username in case we want to display it somewhere later
  final String userId;
  final String username;

  const MyQuestionsPage({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<MyQuestionsPage> createState() => _MyQuestionsPageState();
}

class _MyQuestionsPageState extends State<MyQuestionsPage> {
  // api_service.dart handles all the actual http calls to our fly.io server
  final ApiService api = ApiService();

  // this list will hold all the questions we get back from the server
  List questions = [];

  // we use this to show a loading spinner while we wait for the server to respond
  // once the data comes back we flip it to false and show the list
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // kick off the data fetch as soon as the page opens
    loadQuestions();
  }

  // calls the api to get all questions posted by this specific user
  // widget.userId is the id of whoever is currently logged in
  // once we get the data back, we store it in 'questions' and stop showing the spinner
  Future<void> loadQuestions() async {
    List data = await api.getMyQuestions(widget.userId);
    setState(() {
      questions = data;
      isLoading = false;
    });
  }

  // the date comes back from the database as a raw timestamp string like "2026-05-02T14:33:00.000Z"
  // this function turns that into something readable like "May 2, 2026"
  // we wrap it in a try/catch so if the date format ever changes it won't crash the app
  String _formatDate(String? rawDate) {
    if (rawDate == null) return '';
    try {
      final dt = DateTime.parse(rawDate);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (e) {
      // if the date string is unexpected just return empty so nothing breaks
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Questions')),
      body: isLoading
          // show a centered spinner while the server is fetching the questions
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
          // if the server came back with nothing, show a friendly empty state message
          ? const Center(
              child: Text(
                "you haven't asked anything yet!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          // once we have questions, render them as a scrollable list
          : ListView.separated(
              itemCount: questions.length,
              // a thin divider between each row, indented slightly on both sides
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                // pull out the current question from the list
                final q = questions[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // small grey date text above the question title
                      // created_at comes from the inquiries table in supabase
                      Text(
                        _formatDate(q['created_at']),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // the actual question title the user typed when they posted
                      Text(
                        q['title'] ?? 'no title',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}