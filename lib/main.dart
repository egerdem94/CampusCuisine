import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutroial/screens/auth_screen.dart';
import 'package:firebase_tutroial/services/firebase_helper.dart';
import 'package:firebase_tutroial/services/notification_service.dart';
import 'package:flutter/material.dart';

late final Widget screen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseHelper.setupFirebase();
  await NotificationService.initializeNotification();
  await Firebase.initializeApp();

  screen = FirebaseHelper.homeScreen;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
    );
  }
}
