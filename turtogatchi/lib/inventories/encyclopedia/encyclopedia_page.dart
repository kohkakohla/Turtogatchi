import 'package:flutter/material.dart';
import 'package:turtogatchi/inventories/encyclopedia/components/accessory_encyclopedia_page.dart';
import 'package:turtogatchi/inventories/encyclopedia/components/turtle_encyclopedia_page.dart';

import '../components/footer.dart';

class EncyclopediaPage extends StatefulWidget {
  const EncyclopediaPage({super.key});

  @override
  State<EncyclopediaPage> createState() => _EncyclopediaPageState();
}

class _EncyclopediaPageState extends State<EncyclopediaPage> {
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
              'Encyclopedia',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "MarioRegular",
                fontSize: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/images/Book.png")),
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
                    TurtleEncyclopediaPage(),
                    AccessoryEncyclopediaPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // FOOTER
    );
  }
}
