import 'package:flutter/material.dart';
import '../api_service.dart';
import 'confirm_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AskPage extends StatefulWidget {
  final String userId;
  final String username;
  const AskPage({super.key, required this.userId, required this.username});

  @override
  State<AskPage> createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  final ApiService api = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false; // To show a loading spinner during upload

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // --- IMPROVED FUNCTIONS ---

  // 1. Pick Image with Source Choice, Compression, and Error Handling
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1080, // Reduces file size for faster upload
        imageQuality: 85, // Good balance between size and clarity
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Could not access the camera/gallery: $e');
    }
  }

  // 2. Show the Bottom Sheet for selection
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var listTile = ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () {
            Navigator.pop(context);
            _pickImage(ImageSource.camera);
          },
        );
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              listTile,
            ],
          ),
        );
      },
    );
  }

  // 3. Refined Submit Logic
  Future<void> submitInquiry() async {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // NOTE: You might need to update your api.addInquiry to accept the _imageFile!
      bool success = await api.addInquiry(
        _titleController.text,
        _bodyController.text,
        widget.userId,
        // image: _imageFile, // Ensure your API service supports this
      );

      // Check if the widget is still "mounted" before using context after an await
      if (!mounted) return;

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmPage()),
        );
      } else {
        _showErrorSnackBar('Failed to submit inquiry');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Question')),
      body: SingleChildScrollView(
        // Prevents overflow when keyboard appears
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What's the issue?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Describe your issue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Image Preview/Capture Logic
            if (_imageFile != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _imageFile!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                    onPressed: () => setState(() => _imageFile = null),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: _showImageSourceOptions,
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Add a Photo'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : submitInquiry,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}