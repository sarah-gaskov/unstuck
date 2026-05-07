import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_page.dart';

class UserDetailsPage extends StatefulWidget {
  final String username;
  final String password;
  const UserDetailsPage({super.key, required this.username, required this.password});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ApiService api = ApiService();
  bool _isSigningUp = false;

  String? _selectedMake;
  String? _selectedModel;
  String? _selectedYear;

  final Map<String, List<String>> _carModels = {
    'Toyota': ['Camry', 'Corolla', 'RAV4', 'Tacoma', 'Highlander', 'Prius', '4Runner', 'Tundra'],
    'Honda': ['Civic', 'Accord', 'CR-V', 'Pilot', 'Fit', 'HR-V', 'Odyssey', 'Ridgeline'],
    'Nissan': ['Sentra', 'Altima', 'Maxima', 'Rogue', 'Pathfinder', 'Frontier', 'Murano', 'Armada'],
    'Ford': ['F-150', 'Mustang', 'Explorer', 'Escape', 'Focus', 'Bronco', 'Edge', 'Expedition'],
    'Chevrolet': ['Silverado', 'Malibu', 'Equinox', 'Tahoe', 'Camaro', 'Traverse', 'Colorado', 'Suburban'],
    'Dodge': ['Charger', 'Challenger', 'Durango', 'Ram 1500', 'Journey', 'Dart'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'M3', 'M5', 'X1', 'X7'],
    'Mercedes': ['C-Class', 'E-Class', 'GLE', 'GLC', 'A-Class', 'S-Class', 'GLA'],
    'Hyundai': ['Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Kona', 'Palisade', 'Ioniq'],
    'Kia': ['Forte', 'Optima', 'Sportage', 'Sorento', 'Soul', 'Telluride', 'Stinger'],
    'Subaru': ['Outback', 'Forester', 'Impreza', 'Crosstrek', 'Legacy', 'WRX', 'Ascent'],
    'Jeep': ['Wrangler', 'Grand Cherokee', 'Cherokee', 'Compass', 'Renegade', 'Gladiator'],
    'GMC': ['Sierra', 'Terrain', 'Acadia', 'Yukon', 'Canyon', 'Envoy'],
    'Volkswagen': ['Jetta', 'Passat', 'Tiguan', 'Atlas', 'Golf', 'ID.4'],
    'Mazda': ['Mazda3', 'Mazda6', 'CX-5', 'CX-9', 'MX-5 Miata', 'CX-30'],
    'Audi': ['A3', 'A4', 'A6', 'Q3', 'Q5', 'Q7', 'TT', 'R8'],
    'Lexus': ['IS', 'ES', 'RX', 'NX', 'GX', 'LS', 'UX'],
    'Ram': ['1500', '2500', '3500', 'ProMaster', 'Dakota'],
    'Buick': ['Enclave', 'Encore', 'Envision', 'LaCrosse'],
    'Cadillac': ['Escalade', 'XT5', 'XT4', 'CT5', 'CT4'],
  };

  final List<String> _years = List.generate(37, (index) => (2026 - index).toString());

  Future<void> _handleSignUp() async {
    if (_selectedMake == null || _selectedModel == null || _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your car make, model and year')),
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
        title: const Text('Your Car Info'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Car:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Car Make',
                border: OutlineInputBorder(),
              ),
              value: _selectedMake,
              items: _carModels.keys.map((make) {
                return DropdownMenuItem(value: make, child: Text(make));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMake = value;
                  _selectedModel = null;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Car Model',
                border: OutlineInputBorder(),
              ),
              value: _selectedModel,
              items: _selectedMake == null
                  ? []
                  : _carModels[_selectedMake]!.map((model) {
                      return DropdownMenuItem(value: model, child: Text(model));
                    }).toList(),
              onChanged: _selectedMake == null
                  ? null
                  : (value) {
                      setState(() { _selectedModel = value; });
                    },
              hint: Text(_selectedMake == null ? 'Select make first' : 'Select model'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Year',
                border: OutlineInputBorder(),
              ),
              value: _selectedYear,
              items: _years.map((year) {
                return DropdownMenuItem(value: year, child: Text(year));
              }).toList(),
              onChanged: (value) {
                setState(() { _selectedYear = value; });
              },
            ),
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