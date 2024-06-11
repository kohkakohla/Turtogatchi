import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/inventory/encyclopedia_page.dart';
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
  var animationAsset = "assets/accessory.json";
  var _showFirstAnimation = true;
  var gatchaResult;
  var local_img = "unknownTurtle.png";
  var turtleName = "Unknown Turtle";

  late AnimationController _controller;
  late AnimationController _controllerTwo;
  final AssetsAudioPlayer player = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _controllerTwo = AnimationController(vsync: this);

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
        if (coins >= 5) {
          _enoughCoins = true;
        }
      });
    } else {
      print("User data does not exist!");
    }
    print("Coins: $coins");
    print("Inventory: $inventory");
  }

  void updateCoinsBackend() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'coins': coins});
  }

  void _outputDecider() {
    // Randomly decide the output of the gacha
    var rng = new Random();
    var output = rng.nextInt(100);
    print("Output: $output");

    // 20% chance of getting a turtle
    if (output < 20) {
      print("gatcha is here");
      setState(() {
        animationAsset = "assets/turtle.json";

        gatchaResult = rng.nextInt(4) + 1;
      });
    } else {
      setState(() {
        animationAsset = "assets/accessory.json";
        gatchaResult = 0;
      });
    }
  }

  void _beginSpin() {
    // update coins in firestore'
    if (coins < 5) {
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
        _outputDecider();

        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            if (gatchaResult == 0) {
              setState(() {
                _showFirstAnimation = false;
                animationAsset = "assets/accessory.json";
              });
            } else {
              turtleNameSetState(gatchaResult);
              setState(() {
                _showFirstAnimation = false;
                animationAsset = "assets/turtle.json";
              });
            }
          }
        });
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

  void _updateInventory(String id) async {
    // update user inventory in firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (userDoc.exists) {
      inventory = (userDoc.data() as Map<String, dynamic>)?['inventory'];

      if (!inventory.contains(id)) {
        inventory.add(id);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'inventory': inventory});
      }
    } else {
      print("User data does not exist!");
    }
  }

  void turtleNameSetState(int id) async {
    DocumentSnapshot turtleData = await FirebaseFirestore.instance
        .collection('Turtle')
        .doc('T0$id')
        .get();
    if (turtleData.exists) {
      setState(() {
        // pull data form firebase
        local_img = (turtleData.data() as Map<String, dynamic>)?['local_img'];
        turtleName = (turtleData.data() as Map<String, dynamic>)?['name'];
        _updateInventory('T0$id');
      });
      // update firebase with new turtle in inventory
      //_updateInventory('T0$id');
    } else {
      print("Turtle data does not exist!");
    }
  }

  void _resetState() {
    print(_controller.status);

    if (_controllerTwo.status == AnimationStatus.completed) {
      setState(() {
        _isAnimationActive = false;
        _showButton = true;
        _showFirstAnimation = true;
      });
      _controller.reset();
      _controllerTwo.reset();
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
              "Gacha",
              style: TextStyle(fontFamily: "MarioRegular", fontSize: 18),
            ),
            actions: <Widget>[
              // Inventory button

              Row(
                children: [
                  IconButton(
                      icon: Image.asset("assets/images/backpack.png"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryPage()),
                        );
                      }),
                  IconButton(
                    icon: Image.asset("assets/images/inventory_icon.png"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EncyclopediaPage()),
                      );
                    },
                  ),
                  Text(
                    //coin
                    coins.toString(),
                    style: GoogleFonts.pressStart2p(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
                              backgroundColor:
                                  _enoughCoins ? Colors.green : Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                              minimumSize: const Size(150, 70),
                            ),
                            onPressed: () {
                              _enoughCoins
                                  ? _beginSpin()
                                  : const Dialog(
                                      child: Text("Not enough coins to spin!"));
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
                                    _enoughCoins
                                        ? '5 Coins to spin!'
                                        : 'Not enough coins',
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
                      child: _showFirstAnimation
                          ? Lottie.asset("assets/gatcha.json",
                              controller: _controller, onLoaded: (composition) {
                              _controller
                                ..duration = composition.duration
                                ..forward();
                            })
                          : animationAsset == "assets/turtle.json"
                              ? Stack(
                                  // Stacks on turtle animation
                                  alignment: Alignment.center,
                                  children: [
                                    Lottie.asset(animationAsset,
                                        controller: _controllerTwo,
                                        onLoaded: (composition) {
                                      _controllerTwo
                                        ..duration = composition.duration
                                        ..forward();
                                    }),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/turtle/$local_img",
                                            width: 200,
                                            height: 180,
                                            fit: BoxFit.contain,
                                          ),
                                          Text(
                                            turtleName,
                                            style: GoogleFonts.pressStart2p(
                                              textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          )
                                        ]),
                                  ],
                                )
                              : Lottie.asset(animationAsset,
                                  width: 900,
                                  height: 900,
                                  controller: _controllerTwo,
                                  onLoaded: (composition) {
                                  _controllerTwo
                                    ..duration = composition.duration
                                    ..forward();
                                })

                      // The image is always displayed unless you want it to disappear too
                      )
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
