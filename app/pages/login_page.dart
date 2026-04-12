import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	final ApiService api = ApiService();
	final TextEditingController _usernameController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	bool _isLoading = false;
	
	@override
	void dispose() {
		_usernameController.dispose();
		_passwordController.dispose();
		super.dispose();
	}
	
	Future<void> _handleAuth(bool isLogin) async {
		final username = _usernameController.text.trim();
		final password = _passwordController.text.trim();
		
		if (username.isEmpty || password.isEmpty) {
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('Please enter username and password')),
			);
			return;
		}
		
		setState(() {
			_isLoading = true;
		});
		
		bool success = isLogin
			? await api.loginUser(username, password)
			: await api.registerUser(username, password);
			
		setState(() {
			_isLoading = false;
		});
		
		if (success) {
			if (!mounted) return;
			Navigator.pushReplacement(
				context,
				MaterialPageRoute(builder: (context) => const HomePage()),
			);
		} else {
			if (!mounted) return;
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text(isLogin ? 'Login failed' : 'Registration failed. Username may exist.')),
			);
		}
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // App title
              const Text(
                'UNSTUCK',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 60),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('LOGIN'),
                ),
              ),

              const SizedBox(height: 12),

              // Continue as guest button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('Continue as guest'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}