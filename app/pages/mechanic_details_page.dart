import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_page.dart';


class MechanicDetailsPage extends StatefulWidget {
  final String username;
  final String password;
  const MechanicDetailsPage({super.key, required this.username, required this.password});

  @override
  State<MechanicDetailsPage> createState() => _MechanicDetailsPageState();
}

class _MechanicDetailsPageState extends State<MechanicDetailsPage> {
  final ApiService api = ApiService();
  final TextEditingController _credentialsController = TextEditingController();
  bool _isSigningUp = false;
  bool _hasCredentials = false;
  List<String> _selectedExpertise = [];

  final List<String> _expertiseOptions = [
    'Engine',
    'Brakes',
    'Transmission',
    'Electrical',
    'Suspension',
    'Exhaust',
    'AC & Heating',
    'Tires & Wheels',
    'Oil & Fluids',
    'Body & Paint',
  ];

  @override
  void dispose() {
    _credentialsController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_selectedExpertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one area of expertise')),
      );
      return;
    }

    if (_hasCredentials && _credentialsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your credentials')),
      );
      return;
    }

    setState(() { _isSigningUp = true; });
    bool success = await api.registerUser(widget.username, widget.password);
    setState(() { _isSigningUp = false; });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered! Please login now.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Username may exist.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Expertise'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Areas of Expertise:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._expertiseOptions.map((expertise) {
              return CheckboxListTile(
                title: Text(expertise),
                value: _selectedExpertise.contains(expertise),
                activeColor: Colors.deepPurple,
                onChanged: (checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedExpertise.add(expertise);
                    } else {
                      _selectedExpertise.remove(expertise);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Do you have any credentials?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _hasCredentials = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _hasCredentials ? Colors.deepPurple : Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Center(
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: _hasCredentials ? Colors.white : Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasCredentials = false;
                        _credentialsController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_hasCredentials ? Colors.deepPurple : Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Center(
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: !_hasCredentials ? Colors.white : Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_hasCredentials) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _credentialsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Describe your credentials',
                  hintText: 'e.g. ASE Certified, State License #12345...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 32),
            if (_isSigningUp)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignUp,
                  child: const Text('SIGN UP'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}