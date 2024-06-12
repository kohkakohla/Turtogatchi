import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/inventories/components/footer.dart';

class AccessoryInformationSwitchablePage extends StatefulWidget {
  final String id;
  final String img;
  final String name;
  final String description;

  const AccessoryInformationSwitchablePage({
    Key? key,
    required this.id,
    required this.img,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<AccessoryInformationSwitchablePage> createState() =>
      _AccessoryInformationSwitchablePageState();
}

class _AccessoryInformationSwitchablePageState
    extends State<AccessoryInformationSwitchablePage> {
  final user = FirebaseAuth.instance.currentUser;
  StreamSubscription<DocumentSnapshot>? _turtleDataSubscription;
  String get id => widget.id;
  String accessory = "A00";

  @override
  void initState() {
    super.initState();
    _getTurtleData();
  }

  @override
  void dispose() {
    _turtleDataSubscription
        ?.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
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
          if (mounted) {
            // Check if the widget is still in the tree
            setState(() {
              accessory = snapshot.data()?['accessory'] ?? "A00";
            });
          }
        }
      }, onError: (error) {
        // Handle any errors
        ///print("Error listening to user data changes: $error");
      }) as StreamSubscription<DocumentSnapshot<Object?>>?;
    }
  }

  void updateAccessoryBackend(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('turtleState')
        .doc('turtle')
        .update({'accessory': id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),

      // APPBAR
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(211, 244, 255, 1.0),
        title: Row(
          children: [
            const Text(
              "Accessory Information",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "MarioRegular",
                  fontSize: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Image.asset("assets/images/Book.png"),
            ),
          ],
        ),
      ),

      // MAIN CONTENTS
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TURTLE IMAGE TODO GET FROM BACKEND
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(152, 228, 255, 1.0),
                border: Border.all(
                  color: const Color.fromRGBO(78, 152, 180, 1.0),
                  width: 12,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 8,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      "assets/images/accessories/${widget.img}",
                    ),
                  ),

                  // TURTLE NAME TODO GET FROM BACKEND
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: "MarioOutlined",
                      fontSize: 30,
                    ),
                  ),

                  // TURTLE DETAILS TODO GET FROM BACKEND
                  Column(
                    children: [
                      // DESCRIPTION
                      Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // IMAGE
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      "assets/images/conservation.png"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    textDirection: TextDirection.ltr,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // HEADER
                                      Text(
                                        "Description",
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.description,
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // TODO MAKE THIS BUTTON NICE
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all<Size>(const Size(250, 50)),
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
                  print(accessory);
                  print(id);
                  if (accessory == id && accessory != "A00") {
                    updateAccessoryBackend("A00");
                  } else {
                    updateAccessoryBackend(id);
                  }
                });
                Navigator.pop(context);
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   //MaterialPageRoute(builder: (context) => const HomePage()),
                // );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (accessory == id && accessory != "A00")
                    Text(
                      "Remove Accessory",
                      style: GoogleFonts.pressStart2p(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  else
                    Text(
                      "Switch Accessory",
                      style: GoogleFonts.pressStart2p(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  const Icon(Icons.sync),
                ],
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
