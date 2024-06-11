import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class EarnPopup extends StatefulWidget {
  const EarnPopup({Key? key}) : super(key: key);

  @override
  _EarnPopupState createState() => _EarnPopupState();
}

class _EarnPopupState extends State<EarnPopup> {
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _userDataSubscription;
  var coins = 0;

  InterstitialAd? _ad;
  bool _isAdLoaded = false;

  void _launchURL() async {
    final url = Uri.parse('https://www.turtle-tortoise.com/donate');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
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
          });
        }
      }, onError: (error) {
        // Handle any errors
        ///print("Error listening to user data changes: $error");
      });
    }
  }

  void updateCoinsBackend() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'coins': coins});
  }

  Future<void> _loadAd() async {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (Ad ad) {
          //print('Ad loaded.');
          setState(() {
            _ad = ad as InterstitialAd?;
            _isAdLoaded = true;
          });
          _ad?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (Ad ad) {
              //print('Ad dismissed.');
              setState(() {
                coins += 1;
                updateCoinsBackend();
              });
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          //print('Ad failed to load: $error');
          setState(() {
            _ad = null;
            _isAdLoaded = false;
          });
        },
      ),
    );
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
              "Earn coins",
              style: GoogleFonts.pressStart2p(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ),

          // SUBHEADER
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    "Feed Our Turtles",
                    style: GoogleFonts.pressStart2p(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset("assets/images/miniheart.png"),
                ],
              ),
            ),
          ),

          // TWO BUTTONS, WATCH AD AND DONATE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // WATCH AD BUTTON
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
                  onPressed: _isAdLoaded
                      ? () {
                          _ad?.show();
                          _ad = null;
                          _isAdLoaded = false;
                        }
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Watch Ad",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset("assets/images/tv.png"),
                    ],
                  ),
                ),
              ),

              // DONATE BUTTON
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
                  onPressed: _launchURL,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Donate",
                        style: GoogleFonts.pressStart2p(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      Image.asset("assets/images/donate_handshake.png"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
