import 'package:flutter/material.dart';
import 'package:turtogatchi/popups/earn_coin_popup.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';

import 'gacha/gacha_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const MuseumPopup();
                      },
                    );
                  },
                  child: const Text("Museum"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SettingsPopup();
                      },
                    );
                  },
                  child: const Text("Settings"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const EarnPopup();
                      },
                    );
                  },
                  child: const Text("Earn"),
                ),
              ],
            ),

            // invnetory
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InventoryPage(),
                  ),
                );
              },
              child: const Text("Inventory"),
            ),

            // gacha
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GachaPage(),
                  ),
                );
              },
              child: const Text("Gacha"),
            ),
          ],
        ),
      ),
    );
  }
}
