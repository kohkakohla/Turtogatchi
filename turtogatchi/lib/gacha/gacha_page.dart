import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/global/global.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';

class GachaPage extends StatefulWidget {
  const GachaPage({super.key});
  @override
  GachaPageState createState() => GachaPageState();
}

class GachaPageState extends State<GachaPage> {
  AudioPlayer player = AudioPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _initAudioPlayer() async {
    print("Loading drum audio asset");
    if (player.playing) {
      print("Player is already playing");
      await player.pause();
      print("paused!");
    } else {
      print("Player is not playing");
      player.setAsset("assets/audio/drum.mp3");
      await player.play();
    }
    // await player.pause();
    // await player.stop();
    // Cancel the subscription after getting the current state to avoid memory leaks
  }

  @override
  Widget build(BuildContext context) {
    // TODO MAKE THE GACHAFUNCTIONAL
    _initAudioPlayer();

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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Make AppBar transparent
            title: const Text(
              "Gacha Page",
              style: TextStyle(fontFamily: "MarioRegular"),
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
                onPressed: () {},
              )
            ],
          ),

          // ANIMATION
          body: Center(
            // child: Image.asset("assets/images/gacha.png"),
            child: Lottie.asset("assets/test.json"),
          ),

          // CHARITY BUTTON AT BOTTOM RIGHT
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
                      // Your onPressed code here
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
