import 'package:fireconn/dashboard.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        "/landingpage": (BuildContext context) => new MyApp(),
        "/signup": (BuildContext context) => new SignupPage(),
        "/dashboard": (BuildContext context) => new DashboardPage(),
        "/homepage": (BuildContext context) => new HomePage()
      },
    );
  }
}
