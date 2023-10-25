import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
void main() {
  runApp(const MyApp());
}

final _emailController = TextEditingController();
final _passwordController = TextEditingController();
const storage = FlutterSecureStorage();

Future<void> _login() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  final response = await http.post(
    Uri.parse('http://10.0.2.2:3000/login'),
    body: {'email': email, 'password': password},
  );

  if (response.statusCode == 200) {
    final jwtToken = response.body;

    await storage.write(key: 'jwt', value: jwtToken);

    if (kDebugMode) {
      print('Login successful!');
    }
  } else {
    if (kDebugMode) {
      print('Login failed!');
    }
  }
}

Future<void> fetchData() async {
  final jwtToken = await storage.read(key: 'jwt');

  final response = await http.get(
    Uri.parse('https://yourbackend.com/some_endpoint'),
    headers: {
      'Authorization': 'Bearer $jwtToken',
    },
  );

  if (response.statusCode == 200) {
    // Process your data...
  } else {
    if (kDebugMode) {
      print('Failed to fetch data');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Login App',
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24.0),
            const ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
