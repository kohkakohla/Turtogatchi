import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:turtogatchi/popups/museum_popup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    try {
      print("Loading audio asset");
      player.open(
        Audio("assets/audio/test.mp3"),
        showNotification: true,
        autoStart: true,
      );
      print("Setting loop mode");
      await player.setLoopMode(LoopMode.single);
      print("Playing background music");
      await player.play();
    } catch (error) {
      print("An error occurred: $error");
      // Consider handling the error more gracefully, e.g., showing a user-friendly message.
    }
  }

  void _stopAudioPlayer() async {
    print("stopping audio player");
    await player.stop();
  }

  @override

  //TODO ADD BACKGROUND MUSIC HERE
  Widget build(BuildContext context) {
    print("Building splash screen");
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
          body: SafeArea(
            child: Column(
              children: [
                // MAIN TITLE TEXT AND LOGO
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "TURTOGOTCHI",
                    style: TextStyle(fontFamily: "MarioRegular", fontSize: 28),
                  ),
                ),
                // MAIN LOGO
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/splash/splash.png"),
                ),

                // START
                Padding(
                  padding: const EdgeInsets.only(top: 180),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: Colors.white.withOpacity(0.75),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () {
                        _stopAudioPlayer();
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(28.0),
                        child: Text(
                          "START GAME",
                          style: TextStyle(
                            fontFamily: "MarioRegular",
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Button at bottom right
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
                      "In collaboration with",
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
