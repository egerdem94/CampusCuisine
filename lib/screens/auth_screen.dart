import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/googlesign.dart';
import 'signup.dart'; // Import SignUpScreen
import 'login.dart'; // Import LogInScreen

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple, // Custom color for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Sign Up Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
              SizedBox(height: 20), // Adds space between buttons

              // Log In Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.lightBlue, // Button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Log In'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              SizedBox(height: 20), // Adds space between buttons

              // Google Sign-In Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Button color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () async {
                  User? user = await signInWithGoogle();
                  if (user != null) {
                    // Navigate to the home screen or perform other actions
                  }
                },
                child: Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
