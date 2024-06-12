import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:turtogatchi/inventories/encyclopedia/components/accessory_information.dart';

class AccessoryCard extends StatefulWidget {
  final String id;
  final String img;
  final String name;
  final String description;

  const AccessoryCard({
    Key? key,
    required this.id,
    required this.img,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<AccessoryCard> createState() => _AccessoryCardState();
}

class _AccessoryCardState extends State<AccessoryCard> {
  final user = FirebaseAuth.instance.currentUser;

  String get id => widget.id;
  String get img => widget.img;
  String get name => widget.name;
  String get description => widget.description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccessoryInformationPage(
              id: id,
              img: img,
              name: name,
              description: description,
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
                  "assets/images/accessories/$img",
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
