import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:turtogatchi/firebase_options.dart';
import 'package:turtogatchi/forgot_password.dart';
import 'package:turtogatchi/gacha/gacha_page.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/sign_up.dart';
import 'package:turtogatchi/sign_up_email.dart';
import 'package:turtogatchi/splash.dart';
import 'package:turtogatchi/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  // Ensure Flutter bindings are initialized

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Sign out the user when launching for TESTing purposes
  await FirebaseAuth.instance.signOut();
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building MyApp");
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
          '/gacha': (context) => GachaPage(),
          '/sign_up': (context) => SignUpPage(),
          '/sign_up_email': (context) => SignUpEmailPage(),
          '/forgot_password': (context) => ForgotPasswordPage(),
        });
  }
}
