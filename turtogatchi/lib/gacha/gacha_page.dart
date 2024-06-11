// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';

class GachaPage extends StatefulWidget {
  const GachaPage({super.key});
  @override
  GachaPageState createState() => GachaPageState();
}

class GachaPageState extends State<GachaPage> with TickerProviderStateMixin {
  bool _showButton = true;
  bool _isAnimationActive = false;
  bool _enoughCoins = false;
  final user = FirebaseAuth.instance.currentUser;
  var coins = 0;
  var inventory = [];

  late AnimationController _controller;
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation has completed its single run
        // Perform any action here, like navigating to another page or showing a message
      }
    });
    _getUserData();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    player.dispose();
    super.dispose();
  }

  void _getUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (userData.exists) {
      setState(() {
        coins = (userData.data() as Map<String, dynamic>)?['coins'];
        inventory = (userData.data() as Map<String, dynamic>)?['inventory'];
      });
    } else {
      print("User data does not exist!");
    }
  }

  void updateCoinsBackend() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'coins': coins});
  }

  void _beginSpin() {
    // check if user has enough coins
    // if (Global.coins < 10) {
    //   print("Not enough coins to spin!");
    //   return;
    // }

    // update coins in firestore'
    if (coins < 10) {
      print("Not enough coins to spin!");
      setState(() {});
    } else {
      setState(() {
        _showButton = false;
        _isAnimationActive = true;
        coins -= 5;
        updateCoinsBackend();

        _initAudioPlayer();
        print("Spinning the gacha!");
      });
    }
  }

  void _initAudioPlayer() async {
    print("Loading drum audio assets");
    player.open(
      Audio("assets/audio/drums.mp3"),
      showNotification: true,
      autoStart: true,
    );
    await player.play();

    // await player.pause();
    // await player.stop();
    // Cancel the subscription after getting the current state to avoid memory leaks
  }

  void _resetState() {
    print("reset");
    print(_controller.status);

    if (_controller.status == AnimationStatus.completed) {
      print("reset3");
      setState(() {
        _isAnimationActive = false;
        _showButton = true;
      });
      print("reset2");
      _controller.reset();
      player.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO MAKE THE GACHAFUNCTIONAL

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
              Row(
                children: [
                  IconButton(
                    icon: Image.asset("assets/images/settings_icon.png"),
                    onPressed: () {},
                  ),
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
              )
              // Settings button
            ],
          ),

          // ANIMATION
          body: Center(
            child: Stack(
              alignment:
                  Alignment.center, // Ensure the stack's children are centered
              children: [
                if (_showButton) // Show the button based on the _showButton flag
                  //Image.asset( "assets/images/gacha.png"), // This is the bottom layer

                  Stack(alignment: Alignment.center, children: [
                    Image.asset("assets/images/gacha.png"),
                    Opacity(
                      opacity: 1,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 100),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                              minimumSize: const Size(150, 70),
                            ),
                            onPressed: () {
                              _beginSpin();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/home/coin.png",
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Text(
                                    '5 Coins to spin!',
                                    style: GoogleFonts.pressStart2p(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    )
                  ]),

                if (!_showButton) // Show the Lottie animation when the button is not visible
                  GestureDetector(
                      onTap: () {
                        print("activated");
                        _resetState();
                      },
                      child: Lottie.asset(
                        "assets/test.json",
                        controller: _controller,
                        onLoaded: (composition) {
                          // Set the controller bounds to the duration of the Lottie file
                          _controller
                            ..duration = composition.duration
                            ..forward(); // Play the animation a single time
                        },
                      )),
                // The image is always displayed unless you want it to disappear too
              ],
            ),
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
