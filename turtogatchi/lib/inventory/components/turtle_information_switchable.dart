import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/home.dart';
import 'package:turtogatchi/inventory/components/footer.dart';

class TurtleInformationSwitchablePage extends StatefulWidget {
  final String id;
  final String img;
  final String name;
  final String origin;
  final String rarity;
  final String species;
  final String type;
  final String conservationText;
  final String vulnerable;

  const TurtleInformationSwitchablePage({
    Key? key,
    required this.id,
    required this.img,
    required this.name,
    required this.origin,
    required this.rarity,
    required this.species,
    required this.type,
    required this.conservationText,
    required this.vulnerable,
  }) : super(key: key);

  @override
  State<TurtleInformationSwitchablePage> createState() =>
      _TurtleInformationSwitchablePageState();
}

class _TurtleInformationSwitchablePageState
    extends State<TurtleInformationSwitchablePage> {
  final user = FirebaseAuth.instance.currentUser;
  String get id => widget.id;

  void updateSkinBackend(String turtleSkin) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('turtleState')
        .doc('turtle')
        .update({'current': id});
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
              "Turtle Information",
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
                      "assets/images/local_img/${widget.img}.png",
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
                      // SPECIES
                      Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // IMAGE
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/species.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                textDirection: TextDirection.ltr,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // HEADER
                                  Text(
                                    "Species",
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                    ),
                                  ),

                                  // NAME
                                  Text(
                                    widget
                                        .species, // TURTLE NAME TODO GET FROM BACKEND
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ORIGIN
                      Container(
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            // IMAGE
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/images/origin.png"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                textDirection: TextDirection.ltr,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // HEADER
                                  Text(
                                    "Origin",
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1,
                                    ),
                                  ),

                                  // NAME
                                  Text(
                                    widget
                                        .origin, // TURTLE NAME TODO GET FROM BACKEND
                                    style: GoogleFonts.pressStart2p(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // CONSERVATION STATUS
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
                                        "Conservation",
                                        style: GoogleFonts.pressStart2p(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.1,
                                        ),
                                      ),

                                      // NAME
                                      Row(
                                        children: [
                                          Text(
                                            widget
                                                .vulnerable, // TURTLE NAME TODO GET FROM BACKEND
                                            style: GoogleFonts.pressStart2p(
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Image.asset("assets/images/Book.png"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.conservationText,
                                style: GoogleFonts.pressStart2p(
                                  fontSize: 8,
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
                  updateSkinBackend(id);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Switch Turtle",
                    style: GoogleFonts.pressStart2p(
                      fontSize: 12,
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
