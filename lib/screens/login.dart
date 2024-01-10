import 'package:firebase_tutroial/screens/customerhomescreen.dart';
import 'package:firebase_tutroial/screens/ownerMenuScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutroial/services/firebase_helper.dart'; // Import FirebaseHelper
import 'home.dart'; // Import HomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        String? role = await FirebaseHelper.loginUser(
                            email: emailController.text,
                            password: passwordController.text);

                        setState(() {
                          isLoading = false;
                        });

                        if (role != null) {
                          if (role == 'owner') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => OwnerMenuScreen()),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => CustomerHomeScreen()),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to log in')),
                          );
                        }
                      },
                      child: const Text('Log In'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
