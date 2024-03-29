import 'package:flutter/material.dart';

import '../utils/http.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Register'),
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
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    final username = usernameController.text;
                    final password = passwordController.text;
                    try {
                      await authService.registerUser(username, password);
                      Navigator.of(context).pushReplacementNamed('/login');
                    } catch (e) {
                      print('Registration error: $e');
              
                    }
                  },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color:Color(0xff3EB489),
                        ),
                      )
                    :   Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff3EB489).withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              elevation: 4,
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(
              'Already a user? Log in here',
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
