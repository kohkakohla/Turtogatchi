import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:turtogatchi/inventory/components/turtle_information.dart';

class TurtleCard extends StatefulWidget {
  final bool info;
  final int id;

  const TurtleCard({super.key, required this.info, required this.id});

  @override
  State<TurtleCard> createState() => _TurtleCardState();
}

class _TurtleCardState extends State<TurtleCard> {
  bool get info => widget.info;
  var name;
  var icon;

  void _getTurtleData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Turtle')
        .doc("T0${widget.id}")
        .get();
    if (documentSnapshot.exists) {
      setState(() {
        name = documentSnapshot.get('name');
      });
      // Document exists, access its data

      // Use the data as needed
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TurtleInformationPage(
              tId: widget.id,
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
        child: info
            ? SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO LOGO GOES HERE
                    Image.asset("assets/images/miniheart.png"),
                    // TODO NAME GOES HERE
                    Text(name),
                  ],
                ),
              )
            : SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  children: [
                    const Icon(
                      Icons.question_mark_sharp,
                      color: Color.fromRGBO(88, 89, 90, 1),
                    ),
                    Text(name)
                  ],
                ),
              ),
      ),
    );
  }
}
