import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedingPopup extends StatefulWidget {
  final VoidCallback onFeedPressed;
  final int coins;

  const FeedingPopup(
      {super.key, required this.onFeedPressed, required this.coins});

  @override
  State<FeedingPopup> createState() => _FeedingPopupState();
}

class _FeedingPopupState extends State<FeedingPopup> {
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  var turtleSkin = "T01";
  var hunger = 0;
  var worms = 0;
  bool _wormsToFeed = false;
  

  @override
  void initState() {
    super.initState();
    _getTurtleData();
    _getUserWormCount();
  }

  Future<void> _updateCoins() async {
    if (worms == 0) {
      
      var coins = widget.coins - 2;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'coins': coins});
    }
    else {
      setState(() {
        worms -= 1;
        if (worms == 0) {
          _wormsToFeed = false;
        } else {
          _wormsToFeed = true;
        }
      }); 
    }
    await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'wormCount': worms});
  }

  Future<void> _getUserWormCount() async {
    if (user != null) {
      DocumentSnapshot docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (docRef.exists) {
        setState(() {
          worms = (docRef.data() as Map<String, dynamic>)?['wormCount'];
          if (worms != 0) {
            _wormsToFeed = true;
          }
        });
      } 
    }
  }

  Future<void> _getTurtleData() async {
    if (user != null) {
      _userDataSubscription = FirebaseFirestore.instance
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

  Future<void> updateHungerBackend(int newHungerLevel) async {
    if (user != null) {
      if (newHungerLevel >= 0 && newHungerLevel <= 10) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('turtleState')
            .doc('turtle')
            .update({'hunger': newHungerLevel})
            .then((_) => print('Hunger level updated in the backend.'))
            .catchError((error) => print('Failed to update user: $error'));
      } else if (newHungerLevel > 10) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('turtleState')
            .doc('turtle')
            .update({'hunger': 10})
            .then((_) => print('Hunger level updated in the backend.'))
            .catchError((error) => print('Failed to update user: $error'));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('turtleState')
            .doc('turtle')
            .update({'hunger': 0})
            .then((_) => print('Hunger level updated in the backend.'))
            .catchError((error) => print('Failed to update user: $error'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // BORDER OF DIALOG
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // radius of the outline
        side: const BorderSide(
          color: Color.fromRGBO(25, 67, 89, 1.0), // color of the outline
          width: 12, // width of the outline
        ),
      ),

      // BG COLOR
      backgroundColor: const Color.fromRGBO(236, 249, 255, 1.0),

      // CONTENT
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          //HEADER
          Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Feed Your Turtle!",
                  style: GoogleFonts.pressStart2p(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
          
  

          // SUBHEADER

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // FEED WORM BUTTON
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(125, 175)),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                    elevation: WidgetStateProperty.all<double>(8.0),
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      hunger += 1;
                      updateHungerBackend(hunger);
                      // update backend coins
                      _updateCoins();
                      Navigator.pop(context);
                      widget.onFeedPressed();
                    });
                  },
                  child: 
                  _wormsToFeed
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "FEED",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                          worms.toString() + " Worms",
                          style: GoogleFonts.pressStart2p(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Image.asset("assets/images/worm.png"),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "FEED",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(
                          "2 coins",
                          style: GoogleFonts.pressStart2p(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Image.asset("assets/images/home/coin.png",
                        width: 20,
                        height: 20,
                        ),
                        ],
                        ),
                        Image.asset("assets/images/worm.png"),
                    ],
                  )
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
