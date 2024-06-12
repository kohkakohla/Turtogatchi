import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/feeding/feeding_popup.dart';
import 'package:turtogatchi/inventory/encyclopedia_page.dart';
import 'package:turtogatchi/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/earn_coin_popup.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';
import 'package:cron/cron.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final AssetsAudioPlayer player = AssetsAudioPlayer();
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  StreamSubscription<DocumentSnapshot>? _turtleDataSubscription;
  var cron = Cron();
  var coins = 0;
  var inventory = [];
  var turtleSkin = "T01";
  var hunger = 0;
  var _timeToPoop = false;
  var _wormAnimation = false;
  late AnimationController _controller;

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _getUserData();
    _getTurtleData();
    _scheduledPoop();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the controller
        _controller.reset();

        // Update the state
        setState(() {
          // Set any state variables you need to update here
          // For example, if you want to hide the worm animation
          _wormAnimation = false;
        });
      }
    });
  }

  Future<void> _scheduledPoop() async {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {
        _timeToPoop = true;
      });
      print("time to poop hehe");
    });
  }

  void _cleanTurtle() {
    print("cleaning turtle poop");
    setState(() {
      _timeToPoop = false;
    });
  }

  Future<void> _getUserData() async {
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
      }, onError: (error) {
        // Handle any errors
        print("Error listening to user data changes: $error");
      });
    }
  }

  Future<void> _getTurtleData() async {
    if (user != null) {
      _turtleDataSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('turtleState')
          .doc('turtle')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            turtleSkin = snapshot.data()?['current'] ?? 'T01';
            hunger = snapshot.data()?['hunger'] ?? 5;
          });
        }
      }, onError: (error) {
        // Handle any errors
        ///print("Error listening to user data changes: $error");
      }) as StreamSubscription<DocumentSnapshot<Object?>>?;
    }
  }

  Future<String> _getTurtleSprite() async {
    final doc = await FirebaseFirestore.instance
        .collection('Turtle')
        .doc(turtleSkin)
        .get();

    return doc.data()?['local_img'] ?? '';
  }

  Future<void> _initAudioPlayer() async {
    try {
      print("Loading audio asset for login page");
      player.open(
        Audio("assets/audio/test.mp3"),
        showNotification: true,
        autoStart: true,
      );
      await player.setLoopMode(LoopMode.single);
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
            elevation: 0,
            automaticallyImplyLeading: false, // Make AppBar transparent
            title: const Text(
              "My Farm",
              style: TextStyle(fontFamily: "MarioRegular", fontSize: 24),
            ),
            actions: <Widget>[
              // Inventory button
              IconButton(
                icon: Image.asset("assets/images/backpack.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InventoryPage()),
                  );
                },
              ),

              /// encyclopedia page
              IconButton(
                icon: Image.asset("assets/images/inventory_icon.png"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EncyclopediaPage()),
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
              SizedBox(
                height: 375,
                width: 375,
                child: Align(
                    alignment: Alignment.center,
                    child: FutureBuilder<String>(
                      future: _getTurtleSprite(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // loading circle
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');

                          /// error msg
                        } else {
                          String img = snapshot.data!;
                          return Stack(alignment: Alignment.center, children: [
                            Image.asset("assets/images/turtle/$img"),
                            if (_wormAnimation)
                              Lottie.asset(
                                "assets/eating.json",
                                controller: _controller,
                                onLoaded: (composition) {
                                  _controller.duration = composition.duration;
                                  _controller.forward();
                                },
                              )
                          ] // turtle sprite render
                              );
                        }
                      },
                    )),
              ),

              /*
                HOME BUTTON INCLUDES
                1. CLEAN BUTTON
                1. FEED BUTTON
                2. EARN BUTTON
                3. GATCHA BUTTON
              */
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          // CLEAN BUTTON
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                // clean turtle
                                _cleanTurtle();
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/buttons/broom2.png",
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      "CLEAN",
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
                          // FEED BUTTON
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
                                    return FeedingPopup(
                                      onFeedPressed: () {
                                        //lottie animation to play...
                                        setState(() {
                                          _wormAnimation = true;
                                        });
                                      },
                                      coins: coins,
                                    );
                                  },
                                );
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
                                        horizontal: 6.0),
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
