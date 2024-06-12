import 'package:flutter/material.dart';

class HungerBar extends StatelessWidget {
  final double hungerLevel;

  HungerBar({required this.hungerLevel});

  @override
  Widget build(BuildContext context) {
    String hungerBar = 'assets/images/home/hungerplaceholder.png';
    // String hungerBar = '../assets/images/hungerBar/{$hungerLevel}.png';

    return Image.asset(
      hungerBar,
      fit: BoxFit.cover,
    );
  }
}
