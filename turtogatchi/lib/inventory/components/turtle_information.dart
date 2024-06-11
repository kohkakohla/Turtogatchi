import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventory/components/footer.dart';

class TurtleInformationPage extends StatefulWidget {
  final int tId;
  const TurtleInformationPage({Key? key, required this.tId}) : super(key: key);

  @override
  TurtleInformationPageState createState() => TurtleInformationPageState();
}

class TurtleInformationPageState extends State<TurtleInformationPage> {
  final user = FirebaseAuth.instance.currentUser!;
  var conservationText = "Place holder";
  var local_img = "assets/images/genericturtle.png";
  var name = "unnamed";
  var origin = "unknown";
  var species = "unknown";
  var type = "unknown";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTurtleData();
  }
  // grab data from firestore

  void _getTurtleData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Turtle')
        .doc("T0${widget.tId}")
        .get();
    if (documentSnapshot.exists) {
      print("good it works");
      setState(() {
        conservationText = documentSnapshot.get('conservationText');
        type = documentSnapshot.get('type');
        local_img =
            "assets/images/local_img/" + documentSnapshot.get('local_img');
        name = documentSnapshot.get('name');
        origin = documentSnapshot.get('origin');
        species = documentSnapshot.get('species');
        type = documentSnapshot.get('type');
      });
      // Document exists, access its data

      // Use the data as needed
    } else {
      print("good it dont fucking works");
    }
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
                      local_img,
                    ),
                  ),

                  // TURTLE NAME TODO GET FROM BACKEND
                  Text(
                    name,
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
                                    species, // TURTLE NAME TODO GET FROM BACKEND
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
                                    origin, // TURTLE NAME TODO GET FROM BACKEND
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
                                            "Vulnerable Status", // TURTLE NAME TODO GET FROM BACKEND
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
                                conservationText,
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

            const Footer(),
          ],
        ),
      ),
    );
  }
}
