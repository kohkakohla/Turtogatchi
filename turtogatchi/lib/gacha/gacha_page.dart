import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/inventory/encyclopedia_page.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/museum_popup.dart';

class GachaPage extends StatefulWidget {
  const GachaPage({super.key});
  @override
  GachaPageState createState() => GachaPageState();
}

class GachaPageState extends State<GachaPage> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  // user variables
  var coins = 0;
  var inventory = [];
  bool _enoughCoins = false;
  // animation related variables
  var animationAsset = "assets/itemPulled.json";
  var _showFirstAnimation = true;
  bool _showButton = true;
  // Gatcha variables
  var gatchaResult;
  var turtleResult;
  var accessoryResult;
  // place holder variables
  var wormCount = 0;
  var wormGain = 1;
  var local_img = "unknownTurtle.png";
  var turtleName = "Unknown Turtle";
  var accessoryName = "Unknown Accessory";

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
    _controller.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (userData.exists) {
      setState(() {
        wormCount = (userData.data() as Map<String, dynamic>)['wormCount'];
        coins = (userData.data() as Map<String, dynamic>)['coins'];
        inventory = (userData.data() as Map<String, dynamic>)['inventory'];
        if (coins >= 5) {
          _enoughCoins = true;
        }
      });
    } else {
      print("User data does not exist!");
    }
  }

  Future<void> updateCoinsBackend() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'coins': coins});
  }

  Future<void> _updateWorms() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'wormCount': wormCount});
  }

  Future<void> _updateInventory(String id) async {
    // update user inventory in firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (userDoc.exists) {
      inventory = (userDoc.data() as Map<String, dynamic>)['inventory'];

      if (!inventory.contains(id)) {
        inventory.add(id);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({'inventory': inventory});
      }
    }
  }

  Future<void> accessoryNameSetState(int id) async {
    DocumentSnapshot accessoryData = await FirebaseFirestore.instance
        .collection(' Accessory')
        .doc('A0$id')
        .get();
    if (accessoryData.exists) {
      setState(() {
        local_img =
            "accessories/${(accessoryData.data() as Map<String, dynamic>)['local_img']}";
        accessoryName = (accessoryData.data() as Map<String, dynamic>)['name'];
        _updateInventory('A0$id');
      });
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
        local_img =
            "turtle/${(turtleData.data() as Map<String, dynamic>)['local_img']}.png";
        turtleName = (turtleData.data() as Map<String, dynamic>)['name'];
        _updateInventory('T0$id');
      });
      // update firebase with new turtle in inventory
      //_updateInventory('T0$id');
    }
  }

  void _outputDecider() {
    // Randomly decide the output of the gacha
    var rng = new Random();
    var output = rng.nextInt(100);
    if (mounted) {
      // 20% chance of getting a turtle
      if (output < 20) {
        setState(() {
          animationAsset = "assets/itemPulled.json";

          // current turtles are only 4....
          gatchaResult = 1;
          turtleResult = rng.nextInt(4) + 1;
        });
        turtleNameSetState(turtleResult);
      } else if (output < 70 && output >= 20) {
        // setState(() {
        //   animationAsset = "assets/itemPulled.json";
        //   gatchaResult = 2;
        //   var wormOutput = rng.nextInt(100);
        //   if (wormOutput <= 66) {
        //     wormGain = 1;
        //   } else if (wormOutput > 66 && wormOutput <= 90) {
        //     wormGain = 2;
        //   } else {
        //     wormGain = 5;
        //   }
        //   wormCount += wormGain;
        //   _updateWorms();
        // });
        Future.delayed(Duration(seconds: 2), () {
          // 50% chance of getting an a feed
          setState(() {
            animationAsset = "assets/itemPulled.json";
            gatchaResult = 2;
            var wormOutput = rng.nextInt(100);
            if (wormOutput <= 66) {
              wormGain = 1;
            } else if (wormOutput > 66 && wormOutput <= 90) {
              wormGain = 2;
            } else {
              wormGain = 5;
            }
            wormCount += wormGain;
            _updateWorms();
          });
        });
      } else {
        setState(() {
          animationAsset = "assets/itemPulled.json";
          gatchaResult = 0;
          // current accessory are only 3....
          accessoryResult = rng.nextInt(3) + 1;
        });
        accessoryNameSetState(accessoryResult);
      }
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
        coins -= 5;
        updateCoinsBackend();

        _initAudioPlayer();
        print("Spinning the gacha!");
        _outputDecider();
        if (mounted) {
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _showFirstAnimation = false;
                animationAsset = "assets/itemPulled.json";
              });

              // if (gatchaResult == 0) {
              //   accessoryNameSetState(accessoryResult);
              // } else if (gatchaResult == 1) {
              //   turtleNameSetState(turtleResult);
              // } else if (gatchaResult == 2) {
              //   print("updating worms now");

              //   print("worm count after db update: $wormCount");
              // }
            }
          });
        }
      });
    }
  }

  Future<void> _initAudioPlayer() async {
    if (mounted) {
      player.open(
        Audio("assets/audio/drums.mp3"),
        showNotification: true,
      );
      await player.play();
    }

    // await player.pause();
    // await player.stop();
    // Cancel the subscription after getting the current state to avoid memory leaks
  }

  void _resetState() {
    if (_controllerTwo.status == AnimationStatus.completed) {
      setState(() {
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
                      iconSize: 10,
                      icon: Image.asset(
                          height: 35, width: 35, "assets/images/backpack.png"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryPage()),
                        );
                      }),
                  IconButton(
                    iconSize: 10,
                    icon: Image.asset(
                        height: 35,
                        width: 35,
                        "assets/images/inventory_icon.png"),
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
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Image.asset(
                      height: 35, width: 35, "assets/images/home/coin.png"),
                  Text(
                    //worm
                    wormCount.toString(),
                    style: GoogleFonts.pressStart2p(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Image.asset(height: 30, width: 30, "assets/images/worm.png")
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
                                  height: 30,
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
                                        : 'Need 5 coins to spin',
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
                if (!_showButton)
                  Stack(alignment: Alignment.topCenter, children: [
                    // Show the Lottie animation when the button is not visible
                    GestureDetector(
                        onTap: () {
                          print("activated");

                          _resetState();
                        },
                        child: _showFirstAnimation
                            ? Lottie.asset("assets/gatcha.json",
                                controller: _controller,
                                onLoaded: (composition) {
                                _controller
                                  ..duration = composition.duration
                                  ..forward();
                              })
                            : Stack(
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
                                  gatchaResult == 1
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              Image.asset(
                                                "assets/images/$local_img",
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
                                            ])
                                      : gatchaResult == 0
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                  Image.asset(
                                                    "assets/images/$local_img",
                                                    width: 200,
                                                    height: 180,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Text(
                                                    accessoryName,
                                                    style: GoogleFonts
                                                        .pressStart2p(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  )
                                                ])
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                  Image.asset(
                                                    "assets/images/worm.png",
                                                    width: 200,
                                                    height: 180,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Text(
                                                    wormGain > 1
                                                        ? "$wormGain Wormy Worms!"
                                                        : "Wormy Worm!",
                                                    style: GoogleFonts
                                                        .pressStart2p(
                                                      textStyle:
                                                          const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  )
                                                ])
                                ],
                              ))

                    // The image is always displayed unless you want it to disappear too
                  ])
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
