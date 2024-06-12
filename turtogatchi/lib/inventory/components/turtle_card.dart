import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventory/components/turtle_information.dart';

class TurtleCard extends StatefulWidget {
  final String id;
  final String img;
  final String name;
  final String origin;
  final String rarity;
  final String species;
  final String type;
  final String conservationText;
  final String vulnerable;

  const TurtleCard({
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
  State<TurtleCard> createState() => _TurtleCardState();
}

class _TurtleCardState extends State<TurtleCard> {
  final user = FirebaseAuth.instance.currentUser;

  String get id => widget.id;
  String get img => widget.img;
  String get name => widget.name;
  String get origin => widget.origin;
  String get rarity => widget.rarity;
  String get species => widget.species;
  String get type => widget.type;
  String get conservationText => widget.conservationText;
  String get vulnerable => widget.vulnerable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TurtleInformationPage(
              id: id,
              img: img,
              name: name,
              origin: origin,
              rarity: rarity,
              species: species,
              type: type,
              conservationText: conservationText,
              vulnerable: vulnerable,
            ),
          ),
        ),
      },
      child: Card.outlined(
          elevation: 4,
          color: const Color.fromRGBO(152, 228, 255, 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Color.fromRGBO(78, 152, 180, 1.0),
              width: 2,
            ),
          ),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TODO LOGO GOES HERE
                Image.asset(
                  "assets/images/turtle/$img.png",
                  width: 100,
                  height: 75,
                  fit: BoxFit.contain,
                ),
                // TODO NAME GOES HERE
                Text(
                  name,
                  style: GoogleFonts.pressStart2p(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
