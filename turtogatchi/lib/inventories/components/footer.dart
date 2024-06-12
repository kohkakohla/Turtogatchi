import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 250,
            child: Text(
              "COLLECT ALL THE TURTLES TODAY!",
              style: GoogleFonts.pressStart2p(
                fontSize: 16,
                color: const Color.fromRGBO(
                  25,
                  67,
                  89,
                  1.0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child:
                Image.asset("assets/images/museum_transparent_background.png"),
          ),
        ],
      ),
    );
  }
}
