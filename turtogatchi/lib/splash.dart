import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:turtogatchi/popups/museum_popup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  bool _left = false;

  @override
  void dispose() {
    player.stop();
    player.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initAudioPlayer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground
        // Resume music if needed
        print("loading back up the home audio");
        _resumeMusic();
        break;
      case AppLifecycleState.paused:
        // App is in the background
        print("stopping audio player paused");
        if (!_left) {
          _stopAudioPlayer();
        }

        break;
      case AppLifecycleState.inactive:
        // App is in an inactive state and is not receiving user input
        print("stopping audio player");
        _stopAudioPlayer();
        break;
      case AppLifecycleState.detached:
        print("stopping audio player detached");
        // App is still hosted on a flutter engine but is detached from any host views
        _stopAudioPlayer();
        break;
      case AppLifecycleState.hidden:
        print("stopping audio player hidden");
        // TODO: Handle this case.
        _stopAudioPlayer();
        break;
    }
  }

  void _initAudioPlayer() async {
    try {
      print("Loading audio asset");
      player.open(
        Audio("assets/audio/test.mp3"),
        showNotification: true,
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

  void _resumeMusic() async {
    await player.play();
  }

  void _stopAudioPlayer() async {
    await player.pause();
  }

  void _killAudio() async {
    _left = true;
    await player.stop();
    await player.dispose();
  }

  @override

  //TODO ADD BACKGROUND MUSIC HERE
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
          body: SafeArea(
            child: Column(
              children: [
                // MAIN TITLE TEXT AND LOGO
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                  padding: const EdgeInsets.only(top: 120),
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
                        _killAudio();
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
