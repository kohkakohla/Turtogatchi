import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EarnPopup extends StatelessWidget {
  const EarnPopup({super.key});

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
                  onPressed: () {},
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
                  onPressed: () {},
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
