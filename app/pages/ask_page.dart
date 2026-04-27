import 'package:flutter/material.dart';
import '../api_service.dart';
import 'confirm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AskPage extends StatefulWidget {
  const AskPage({super.key});
  @override
  State<AskPage> createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  final ApiService api = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  File? _imageFile;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> submitInquiry() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    bool success = await api.addInquiry(
      _titleController.text,
      _bodyController.text,
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ConfirmPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit inquiry')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask a Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What's the issue?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Describe your issue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Capture Image button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Capture Image'),
              ),
            ),
            const SizedBox(height: 16),
            // Display the captured image if it exists
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 150.0,
              ),
            const SizedBox(height: 24),
            // Upload button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitInquiry,
                child: const Text('Upload'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
