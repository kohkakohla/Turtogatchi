import 'package:flutter/material.dart';

class HungerBar extends StatelessWidget {
  final int hungerLevel;

  HungerBar({required this.hungerLevel});

  @override
  Widget build(BuildContext context) {
    String spriteName = '../assets/images/hungerplaceholder.png';

    return Image.asset(
      spriteName,
      fit: BoxFit.cover,
    );
  }
}
