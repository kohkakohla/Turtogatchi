import 'package:flutter/material.dart';

class TurtleCard extends StatefulWidget {
  final bool info;

  const TurtleCard(this.info, {super.key});

  @override
  State<TurtleCard> createState() => _TurtleCardState(info);
}

class _TurtleCardState extends State<TurtleCard> {
  bool hasInformation = false;

  _TurtleCardState(info) {
    hasInformation = info;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
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
        child: hasInformation
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // TODO LOGO GOES HERE
                  Image.asset("assets/images/miniheart.png"),
                  // TODO NAME GOES HERE
                  const Text("Heart"),
                ],
              )
            : const Center(
                child: Icon(
                  Icons.question_mark_sharp,
                  color: Color.fromRGBO(78, 152, 180, 1.0),
                ),
              ),
      ),
    );
  }
}
