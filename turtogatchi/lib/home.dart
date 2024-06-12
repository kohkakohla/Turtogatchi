import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:lottie/lottie.dart';
import 'package:turtogatchi/feeding/feeding_popup.dart';
import 'package:turtogatchi/inventories/encyclopedia/encyclopedia_page.dart';
import 'package:turtogatchi/inventories/inventory/inventory_page.dart';
import 'package:turtogatchi/popups/earn_coin_popup.dart';
import 'package:turtogatchi/popups/museum_popup.dart';
import 'package:turtogatchi/popups/settings_popup.dart';
import 'package:cron/cron.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AssetsAudioPlayer player;
  late AssetsAudioPlayer player2;
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  StreamSubscription<DocumentSnapshot>? _turtleDataSubscription;
  var cron = Cron();
  var coins = 0;
  var inventory = [];
  var turtleSkin = "T01";
  double hunger = 5.0;
  var _isDirty = false;
  var wormCount = 0;
  var _wormAnimation = false;
  var _cleaningAnimation = false;
  late AnimationController _controller;
  late AnimationController _controllerClean;

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    _controller.dispose();
    _controllerClean.dispose();
    _userDataSubscription?.cancel();
    _turtleDataSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_initAudioPlayer();
    _getUserData();
    _getTurtleData();
    _scheduledPoop();
    _controller = AnimationController(vsync: this);
    _controllerClean = AnimationController(vsync: this);
    WidgetsBinding.instance.addObserver(this);
    _loadMusic();

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
    _controllerClean.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reset the controller
        _controllerClean.reset();

        // Update the state
        setState(() {
          // Set any state variables you need to update here
          // For example, if you want to hide the worm animation
          _isDirty = false;
          _cleaningAnimation = false;
        });
      }
    });
  }

  void _loadMusic() async {
    player = AssetsAudioPlayer();
    await player.open(Audio("assets/audio/test.mp3"));
    await player.setLoopMode(LoopMode.single);
    await player.play();
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
      case AppLifecycleState.paused:
        // App is in the background
        print("stopping audio player paused");
        _stopMusic();
      case AppLifecycleState.inactive:
        // App is in an inactive state and is not receiving user input
        print("stopping audio player");
        _stopMusic();
      case AppLifecycleState.detached:
        print("stopping audio player detached");
        // App is still hosted on a flutter engine but is detached from any host views
        _stopMusic();
      case AppLifecycleState.hidden:
        print("stopping audio player hidden");
        // TODO: Handle this case.
        _stopMusic();
    }
  }

  Future<void> _scheduledPoop() async {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      setState(() {
        if (!_isDirty) {
          _isDirty = true;
        }

        if (hunger > 0) {
          hunger -= 0.5;
        }
        print("hunger: $hunger");
        _updateHunger();
      });
    });
  }

  void _updateHunger() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('turtleState')
        .doc('turtle')
        .update({'hunger': hunger});
  }

  void _cleanTurtle() {
    setState(() {
      _isDirty = false;
      _cleaningAnimation = true;
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
            wormCount = snapshot.data()?['wormCount'] ?? 10;
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
            hunger = snapshot.data()?['hunger'] ?? 5.0;
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
    final hatData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('turtleState')
        .doc('turtle')
        .get();
    if (hatData.exists) {
      final hat = hatData.data()?['accessory'] ?? '';
      if (hat == 'A00') {
        return doc.data()?['local_img'] + ".png" ?? '';
      } else {
        final hatName = await FirebaseFirestore.instance
            .collection(' Accessory')
            .doc(hat)
            .get();
        return doc.data()?['local_img'] + hatName.data()?['local_img'] ?? '';
      }
    }
    return doc.data()?['local_img'] ?? '';
  }

  Future<void> _initAudioPlayer() async {
    try {
      print("Loading audio asset for login page");
      if (!player.isPlaying.value) {
        player.open(
          Audio("assets/audio/test.mp3"),
          showNotification: true,
        );
        await player.setLoopMode(LoopMode.single);
        await player.play();
      }
    } catch (error) {
      print("An error occurred: $error");
      // Consider handling the error more gracefully, e.g., showing a user-friendly message.
    }
  }

  void _resumeMusic() async {
    await player.play();
  }

  void _stopMusic() async {
    await player.pause();
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
                    Text("")
                    // Image.asset(
                    //     width: 150,
                    //     height: 50,
                    //     "assets/images/hunger/$hunger.png"),
                    // Text(
                    //   //coin
                    //   coins.toString(),
                    //   style: GoogleFonts.pressStart2p(
                    //     textStyle: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    // ),
                    // Image.asset("assets/images/home/coin.png"),
                    // Text(
                    //   wormCount.toString(),
                    //   style: GoogleFonts.pressStart2p(
                    //     textStyle: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    // ),
                    // Image.asset(
                    //     height: 40,
                    //     width: 40,
                    //     "assets/images/worm.png") // worm count
                  ],
                ),
              ),
              SizedBox(
                height: 360,
                width: 360,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: Image.asset("assets/images/turtle/$img"),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 220),
                                child: Image.asset(
                                    width: 150,
                                    "assets/images/hunger/$hunger.png")),
                            if (_wormAnimation)
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Transform.scale(
                                      scale: 1.5,
                                      child: Lottie.asset(
                                        "assets/eating.json",
                                        controller: _controller,
                                        onLoaded: (composition) {
                                          _controller.duration =
                                              composition.duration;
                                          _controller.forward();
                                        },
                                      )))
                            else if (_isDirty)
                              Transform.scale(
                                  scale: 1.1,
                                  child: Image.asset("assets/images/poop.png"))
                            //Image.asset("assets/images/poop.png")
                            else if (_cleaningAnimation)
                              Transform.scale(
                                  scale: 1.1,
                                  child: Lottie.asset(
                                    "assets/clean.json",
                                    controller: _controllerClean,
                                    onLoaded: (composition) {
                                      _controllerClean.duration =
                                          composition.duration;
                                      _controllerClean.forward();
                                    },
                                  )
                                  // do smth
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
                padding: const EdgeInsets.only(bottom: 0.0),
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
                                if (_isDirty) {
                                  _cleanTurtle();
                                } else {
                                  // dialoug box
                                }
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Image.asset(
                                      "assets/images/buttons/toilet.png",
                                      height: 50,
                                    ),
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
                                          hunger += 1;
                                          _updateHunger();
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                                _stopMusic();
                                Navigator.pushNamed(
                                  context,
                                  '/gacha',
                                ).then((_) {
                                  _resumeMusic();
                                });
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/buttons/egg.png",
                                    height: 50,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
