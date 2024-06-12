import 'package:flutter/material.dart';

class CustomRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  bool activeHome = false;
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/home') {
      // Assuming '/' is the route name for home.dart
      print('Home Page has been pushed');
      activeHome = true;
      // Perform your actions here
    }
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name == '/') {
      print('Leaving Home Page');
      // Perform your actions here
    }
  }
}
