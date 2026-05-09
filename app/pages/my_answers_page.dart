import 'package:flutter/material.dart';
import '../api_service.dart';

// this page is for mechanics only — it shows all the answers they have submitted
// each row shows when they answered, who asked the question, and what they said
// reference: api endpoint is GET /api/my-answers/:userId in server.js

class MyAnswersPage extends StatefulWidget {
  // userId is the mechanic's id — we use it to fetch only their answers from the server
  // username is the mechanic's name in case we want to display it later
  final String userId;
  final String username;

  const MyAnswersPage({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<MyAnswersPage> createState() => _MyAnswersPageState();
}

class _MyAnswersPageState extends State<MyAnswersPage> {
  // api_service.dart handles all the actual http calls to our fly.io server
  final ApiService api = ApiService();

  // this list holds all the answers we get back from the server
  // each item also contains info about the question it was answering (title, asker username)
  List answers = [];

  // controls the loading spinner — true while waiting for the server, false once data arrives
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // start fetching answers as soon as the page opens
    loadAnswers();
  }

  // calls the api to get all answers submitted by this specific mechanic
  // the server joins answers with inquiries and users so we get the question
  // title and asker username back in the same response — no extra calls needed
  Future<void> loadAnswers() async {
    List data = await api.getMyAnswers(widget.userId);
    setState(() {
      answers = data;
      isLoading = false;
    });
  }

  // the date comes back from the database as a raw timestamp like "2026-05-02T14:33:00.000Z"
  // this converts it to something readable like "May 2, 2026"
  // wrapped in try/catch so a weird date format won't crash the page
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
      appBar: AppBar(title: const Text('My Answers')),
      body: isLoading
          // show a centered spinner while we wait for the server to respond
          ? const Center(child: CircularProgressIndicator())
          : answers.isEmpty
          // if the mechanic hasn't answered anything yet, show a friendly message
          ? const Center(
              child: Text(
                "you haven't answered anything yet!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          // once we have answers, render them as a scrollable list
          : ListView.separated(
              itemCount: answers.length,
              // thin divider between each row, indented slightly on both sides
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 0.5,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                // pull out the current answer from the list
                final a = answers[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // small grey date text — when this answer was submitted
                      // created_at comes from the answers table in supabase
                      Text(
                        _formatDate(a['created_at']),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // the username of the person who asked the question
                      // this comes from the join with users in the server query
                      Text(
                        a['username'] ?? 'unknown user',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // the actual answer text the mechanic submitted
                      // body comes from the answers table in supabase
                      Text(
                        a['body'] ?? 'no answer text',
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