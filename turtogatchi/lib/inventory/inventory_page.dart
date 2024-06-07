import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventory/components/turtle_card_generator.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

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
              child: Image.asset("assets/images/Book.png"),
            ),
          ],
        ),
      ),

      // INVENTORY CARD DISPLAY
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ROW 1
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 15,
                        children: [
                          for (var i = 0; i < 5; i++) cardGenerator(true),
                          for (var i = 0; i < 15; i++) cardGenerator(false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // FOOTER
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(
                        "COLLECT ALL THE TURTLES TODAY!",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 16,
                          color: const Color.fromRGBO(
                            25,
                            67,
                            89,
                            1.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Image.asset(
                          "assets/images/museum_transparent_background.png"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
