import 'package:flutter/material.dart';

import '../utils/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xff3EB489),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Theme.of(context).backgroundColor.withOpacity(0.95),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff3EB489),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Add some vertical spacing
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff3EB489),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      final username = usernameController.text;
                      final password = passwordController.text;

                      try {
                        final token =
                            await authService.loginUser(username, password);
                        if (token != null) {
                          print("success");
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          print('Login failed');
                        }
                      } catch (e) {
                        print('Login error: $e');
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: isLoading
                      ? Center(
                        child: CircularProgressIndicator(
                            color: Color(0xff3EB489),
                          ),
                      )
                      : Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff3EB489),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 4,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/register');
            },
            child: Text(
              'Not a user yet? Register here',
              style: TextStyle(
                color: Color(0xff3EB489),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
