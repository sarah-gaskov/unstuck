import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
	runApp(const MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({super.key});
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Unstuck',
			theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
			home: const HomePage(),
		);
	}
}

class HomePage extends StatefulWidget {
	const HomePage({super.key});
	@override
	State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
	final ApiService api = ApiService();
	bool serverRunning = false;
	List inquiries = [];
	List answers = [];

	final TextEditingController _inqTitleController = TextEditingController();
	final TextEditingController _inqBodyController = TextEditingController();

	final TextEditingController _ansIdController = TextEditingController();
	final TextEditingController _ansBodyController = TextEditingController();

	@override
	void initState() {
		super.initState();
		loadData();
	}

	@override
	void dispose() {
		_inqTitleController.dispose();
		_inqBodyController.dispose();
		_ansIdController.dispose();
		_ansBodyController.dispose();
		super.dispose();
	}

	Future<void> loadData() async {
		bool status = await api.checkServer();
		List data_inq = await api.getInquiries();
		List data_ans = await api.getAnswers();
    
		setState(() {
			serverRunning = status;
			inquiries = data_inq;
			answers = data_ans;
		});
	}

	Future<void> addInquiry(String title, String body) async {
		await api.addInquiry(title, body);
    
		_inqTitleController.clear();
		_inqBodyController.clear();
		loadData();
	}

	Future<void> addAnswer(int inquiryId, String body) async {
		await api.addAnswer(inquiryId, body);
	
		_ansIdController.clear();
		_ansBodyController.clear();
		loadData();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				backgroundColor: Theme.of(context).colorScheme.inversePrimary,
				title: const Text('Unstuck'),
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(serverRunning ? 'Server: Connected' : 'Server: Disconnected'),
						const SizedBox(height: 16),
            
						Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
			  
								// ADD INQUIRY
								Expanded(
									child: Card(
										elevation: 2,
										child: Padding(
											padding: const EdgeInsets.all(8.0),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													const Text('Make Inquiry', style: TextStyle(fontWeight: FontWeight.bold)),
													TextField(
														controller: _inqTitleController,
														decoration: const InputDecoration(labelText: 'Title', isDense: true),
													),
													TextField(
														controller: _inqBodyController,
														decoration: const InputDecoration(labelText: 'Body', isDense: true),
													),
													const SizedBox(height: 8),
													ElevatedButton(
														onPressed: () {
															addInquiry(
																_inqTitleController.text,
																_inqBodyController.text,
															);
														},
														child: const Text('Add Inquiry'),
													)
												],
											),
										),
									),
								),
                
								const SizedBox(width: 16),
                
								// ADD ANSWER
								Expanded(
									child: Card(
										elevation: 2,
										child: Padding(
											padding: const EdgeInsets.all(8.0),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													const Text('Make Answer', style: TextStyle(fontWeight: FontWeight.bold)),
													TextField(
														controller: _ansIdController,
														decoration: const InputDecoration(labelText: 'Inquiry ID', isDense: true),
														keyboardType: TextInputType.number,
													),
													TextField(
														controller: _ansBodyController,
														decoration: const InputDecoration(labelText: 'Body', isDense: true),
													),
													const SizedBox(height: 8),
													ElevatedButton(
														onPressed: () {
															int? parsedId = int.tryParse(_ansIdController.text);
															if (parsedId != null) {
																addAnswer(
																	parsedId,
																	_ansBodyController.text,
																);
															} else {
																ScaffoldMessenger.of(context).showSnackBar(
																	const SnackBar(content: Text('Please enter a valid Integer ID')),
																);
															}
														},
														child: const Text('Add Answer'),
													)
												],
											),
										),
									),
								),
							],
						),

						const SizedBox(height: 24),

						// INQUIRIES LIST
						const Text('Inquiries:', style: TextStyle(fontWeight: FontWeight.bold)),
						const SizedBox(height: 8),
						Expanded(
							child: ListView.builder(
								itemCount: inquiries.length,
								itemBuilder: (context, index) {
									final item = inquiries[index];
									return Padding(
										padding: const EdgeInsets.symmetric(vertical: 4.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(item['title'] ?? 'No title', style: const TextStyle(fontWeight: FontWeight.bold)),
												Text(item['body'] ?? ''),
												Text(item['inquiry_id']?.toString() ?? '0'),
											],
										),
									);
								},
							),
						),
            
						const SizedBox(height: 16),
            
						// ANSWERS LIST
						const Text('Answers:', style: TextStyle(fontWeight: FontWeight.bold)),
						const SizedBox(height: 8),
						Expanded(
							child: ListView.builder(
								itemCount: answers.length,
								itemBuilder: (context, index) {
									final item = answers[index];
									return Padding(
										padding: const EdgeInsets.symmetric(vertical: 4.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text(item['inquiry_id']?.toString() ?? '0', style: const TextStyle(fontWeight: FontWeight.bold)),
												Text(item['body'] ?? ''),
											],
										),
									);
								},
							),
						),
					],
				),
			),
		);
	}
}