import 'package:flutter/material.dart';
import '../api_service.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ApiService api = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _credentialsController = TextEditingController();
  bool _isSigningUp = false;

  //User type selection
  String _userType = 'user';

  //Car info for users
  String? _selectedMake;
  String? _selectedModel;
  String? _selectedYear;

  //Expertise for mechanics
  List<String> _selectedExpertise = [];

  //Credentials for mechanics
  bool _hasCredentials = false;

  //Car makes and models
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

  // Expertise options for mechanics
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

  // Years from 2026 down to 1940
  final List<String> _years = List.generate(
    86,
    (index) => (2026 - index).toString(),
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _credentialsController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    if (_userType == 'user' && (_selectedMake == null || _selectedModel == null || _selectedYear == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your car make, model and year')),
      );
      return;
    }

    if (_userType == 'mechanic' && _selectedExpertise.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one area of expertise')),
      );
      return;
    }

    if (_userType == 'mechanic' && _hasCredentials && _credentialsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your credentials')),
      );
      return;
    }

    setState(() { _isSigningUp = true; });

    bool success = await api.registerUser(username, password);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'UNSTUCK',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 40),

              // Username field
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Enter a Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter a Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // User type selection
              const Text(
                'I am a:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _userType = 'user';
                          _selectedExpertise = [];
                          _hasCredentials = false;
                          _credentialsController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _userType == 'user'
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple),
                        ),
                        child: Center(
                          child: Text(
                            'User',
                            style: TextStyle(
                              color: _userType == 'user' ? Colors.white : Colors.deepPurple,
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
                          _userType = 'mechanic';
                          _selectedMake = null;
                          _selectedModel = null;
                          _selectedYear = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _userType == 'mechanic'
                              ? Colors.deepPurple
                              : Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.deepPurple),
                        ),
                        child: Center(
                          child: Text(
                            'Mechanic',
                            style: TextStyle(
                              color: _userType == 'mechanic' ? Colors.white : Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //User fields - car info
              if (_userType == 'user') ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Car:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
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
                          setState(() {
                            _selectedModel = value;
                          });
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
                    setState(() {
                      _selectedYear = value;
                    });
                  },
                ),
              ],

              //Mechanic fields
              if (_userType == 'mechanic') ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Areas of Expertise:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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

                // Credentials section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Do you have any credentials?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _hasCredentials = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _hasCredentials
                                ? Colors.deepPurple
                                : Colors.deepPurple.shade50,
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
                            color: !_hasCredentials
                                ? Colors.deepPurple
                                : Colors.deepPurple.shade50,
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
              ],

              const SizedBox(height: 32),

              if (_isSigningUp)
                const CircularProgressIndicator()
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
      ),
    );
  }
}