import 'package:flutter/material.dart';
import 'package:turtogatchi/popups/earn_coins.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return MuseumPopup();
                  },
                );
              },
              child: Text("Museum"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SettingsPopup();
                  },
                );
              },
              child: Text("Settings"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EarnPopup();
                  },
                );
              },
              child: Text("Earn"),
            ),
          ],
        ),
      ),
    );
  }
}
