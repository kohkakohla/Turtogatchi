import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:turtogatchi/firebase_options.dart';
import 'package:turtogatchi/forgot_password.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/sign_up.dart';
import 'package:turtogatchi/sign_up_email.dart';
import 'package:turtogatchi/splash.dart';
import 'package:turtogatchi/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';



void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized
  
  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Sign out the user when launching for TESTing purposes
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/sign_up': (context) => SignUpPage(),
          '/sign_up_email': (context) => SignUpEmailPage(),
          '/forgot_password': (context) => ForgotPasswordPage(),
        });
  }
}
