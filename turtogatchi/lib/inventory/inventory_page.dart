import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/accessory_inventory_page.dart';
import 'package:turtogatchi/inventory/turtle_inventory_page.dart';

import 'components/footer.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),

      // APPBAR
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),
        title: Row(
          children: [
            const Text(
              'Inventory',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "MarioRegular",
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/images/backpack.png")),
            ),
          ],
        ),
      ),

      // INVENTORY CARD DISPLAY
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                color: const Color.fromRGBO(211, 244, 255, 1.0),
                child: TabBar(
                  tabs: [
                    Tab(icon: Image.asset("./assets/images/mini_turtle.png")),
                    Tab(icon: Image.asset("./assets/images/default_hat.png")),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    TurtleInventoryPage(),
                    AccessoryInventoryPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // FOOTER
      bottomNavigationBar: const Footer(),
    );
  }
}
