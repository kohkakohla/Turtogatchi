import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';

import 'home_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage("https://i.imgur.com/nFTIczm.png"),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,

          //APPBAR
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Make AppBar transparent
            title: const Text(
              "My Farm",
              style: TextStyle(fontFamily: "MarioRegular", fontSize: 32),
            ),
            actions: <Widget>[
              // Inventory button
              IconButton(
                icon: Image.asset("assets/images/inventory_icon.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InventoryPage()),
                  );
                },
              ),

              // Settings button
              IconButton(
                icon: Image.asset("assets/images/settings_icon.png"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const SettingsPopup();
                    },
                  );
                },
              )
            ],
          ),

          // MAIN BODY
          body: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      // TODO THIS IS THE COIN AMOUNT FROM BACKEND.
                      "13",
                      style: GoogleFonts.pressStart2p(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Image.asset("assets/images/home/coin.png")
                  ],
                ),
              ),
              // TURTLE TODO GET FROM DB?
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset("assets/images/home/tigress.png"),
                ),
              ),
              // TODO THIS IS THE WORM ANIMATION idk how use
              // SizedBox(
              //   child: Lottie.asset("assets/images/eating.json"),
              // ),
              // BUTTONS
              const HomeButtons()
            ],
          ),

          // CHARITY BUTTON
          floatingActionButton: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "Click To Find Out How You Can Help!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pressStart2p(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const MuseumPopup();
                        },
                      );
                    },
                    child: Image.asset(
                      "assets/images/gachapage/Collaboration.png",
                      height: 200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
