import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turtogatchi/firebase_options.dart';
import 'package:turtogatchi/login/forgot_password.dart';
import 'package:turtogatchi/gacha/gacha_page.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/login/sign_up.dart';
import 'package:turtogatchi/login/sign_up_email.dart';
import 'package:turtogatchi/splash.dart';
import 'package:turtogatchi/login/login.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/splash.dart';
import 'package:turtogatchi/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:turtogatchi/routeObserver.dart';

void main() async {
  final RouteObserver = CustomRouteObserver();
  runApp(ProviderScope(
      child: MyApp(
    routeObserver: RouteObserver,
  )));
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter bindings are initialized

  // initialize firebase

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Sign out the user when launching for TESTing purposes
  //await FirebaseAuth.instance.signOut();
}

class MyApp extends StatelessWidget {
  final CustomRouteObserver routeObserver;
  const MyApp({super.key, required this.routeObserver});

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
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => const HomePage(),
        '/gacha': (context) => const GachaPage(),
        '/sign_up': (context) => SignUpPage(),
        '/sign_up_email': (context) => const SignUpEmailPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}
