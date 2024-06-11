import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:turtogatchi/gacha/gacha_page.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/earn_coin_popup.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  //default values
  var coins = 0;
  var inventory = [];

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _getUserData();
  }

  void _getUserData() async {
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            coins = snapshot.data()?['coins'] ?? 0;
            inventory = snapshot.data()?['inventory'] ?? [];
          });
        }
        print("Coins: $coins");
        print("Inventory: $inventory");
      }, onError: (error) {
        // Handle any errors
        print("Error listening to user data changes: $error");
      });
    }
  }

  void _initAudioPlayer() async {
    try {
      print("Loading audio asset for login page");
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

  void resetAudio() async {
    await player.stop();
    await player.play();
  }

  void _stopMusic() async {
    print("stopping audio player");
    await player.stop();
  }

  // grab

  @override
  // TODO ADD BACKGROUD MUSIC HERE
  Widget build(BuildContext context) {
    resetAudio();
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
                      //coin
                      coins.toString(),
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
              // TURTLE TODO GET FROM DB THE TURTLE.
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
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          // FEED BUTTON
                          // TODO MAKE THIS FUNCTIONAL!!!
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                // TODO HEREHEREHEREHEHEHERHERHE
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/buttons/Spoon.png",
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "FEED",
                                      style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          // EARN BUTTON
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const EarnPopup();
                                  },
                                );
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/buttons/monie.png",
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "EARN",
                                      style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 7,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          // GACHA BUTTON
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                player.stop();
                                Navigator.pushNamed(
                                  context,
                                  '/gacha',
                                );
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/buttons/egg.png",
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "HATCH",
                                      style: GoogleFonts.pressStart2p(
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
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
