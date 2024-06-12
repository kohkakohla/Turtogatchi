import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventory/components/footer.dart';

class TurtleInformationPage extends StatelessWidget {
  final String id;
  final String img;
  final String name;
  final String origin;
  final String rarity;
  final String species;
  final String type;
  final String conservationText;
  final String vulnerable;

  const TurtleInformationPage({
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
                      "assets/images/local_img/$img.png",
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
                                            vulnerable, // TURTLE NAME TODO GET FROM BACKEND
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
